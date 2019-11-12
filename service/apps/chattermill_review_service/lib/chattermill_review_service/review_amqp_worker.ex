defmodule ChattermillReviewService.ReviewAMQPWorker do
  @moduledoc false
  use GenServer
  require Logger
  alias AMQP.{Connection, Channel, Queue, Basic}
  alias ChattermillReviewService.Reviews

  def start_link(opts \\ []) do
    opts = Keyword.put(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def publish_review(attrs) do
    case GenServer.call(__MODULE__, {:publish_review, Jason.encode!(attrs)}) do
      {:ok, payload} ->
        {:ok, payload}

      {:error, reason, payload} ->
        Logger.error("Failed to publish message with payload: #{payload}. Reason:#{reason}")
    end
  rescue
    exception ->
      Logger.error("Error receiving the message to publish review.")
      Logger.error(Exception.message(exception))
      {:error, exception.message, attrs}
  end

  # Publishing a new review message got from the call made on publish_review/1
  def handle_call({:publish_review, payload}, _from, channel) do
    {_, _, queue_name, _} = connection_config()

    case AMQP.Basic.publish(channel, "", queue_name, payload, mandatory: true, persistent: true) do
      :ok ->
        {:reply, {:ok, payload}, channel}

      {:error, reason} ->
        {:reply, {:error, reason, payload}, channel}
    end
  end

  def init(_) do
    {:ok, nil, {:continue, :connect}}
  end

  def handle_continue(:connect, _) do
    {host, port, queue_name, reconnect_interval} = connection_config()

    case Connection.open(host: host, port: port) do
      {:ok, conn} ->
        Process.monitor(conn.pid)
        {:ok, channel} = Channel.open(conn)
        Queue.declare(channel, queue_name, durable: true)
        {:ok, _consumer_tag} = Basic.consume(channel, queue_name)

        {:noreply, channel}

      {:error, _} ->
        Logger.warn("Failed to connect to amqp://#{host}:#{port}. Reconnecting later...")
        {:noreply, nil, reconnect_interval}
    end
  end

  def handle_info(:timeout, _) do
    {host, port, _, _} = connection_config()
    Logger.info("Retry connect to #{host}:#{port}.")
    {:noreply, nil, {:continue, :connect}}
  end

  def handle_info({:DOWN, _, :process, _pid, reason}, _) do
    Logger.warn("AMQP Connection down. Reason: #{reason}")
    Logger.warn("Stopping the GenServer. The Supervisor will restart it.")
    {:stop, {:connection_lost, reason}, nil}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, _meta}, channel) do
    {:noreply, channel}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, _meta}, channel) do
    {:stop, :normal, channel}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, _meta}, channel) do
    {:noreply, channel}
  end

  def handle_info({:basic_deliver, payload, meta}, channel) do
    consume(channel, meta, payload)
    {:noreply, channel}
  end

  defp consume(channel, %{delivery_tag: tag, redelivered: redelivered}, payload) do
    attrs = Jason.decode!(payload)
    {:ok, _review} = Reviews.create_review(attrs)
    :ok = Basic.ack(channel, tag)
  rescue
    exception ->
      :ok = Basic.reject(channel, tag, requeue: not redelivered)
      Logger.error("Error receiving the message with payload: #{payload}")
      Logger.error(Exception.message(exception))
  end

  defp connection_config do
    {
      System.get_env("AMQP_HOST", "localhost"),
      String.to_integer(System.get_env("AMQP_PORT", "30003")),
      Application.get_env(:chattermill_review_service, ReviewAMQPWorker)[:queue] ||
        System.get_env("AMQP_QUEUE", "chattermill_review_dev"),
      10_000
    }
  end
end
