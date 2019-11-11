defmodule ChattermillReviewService.ReviewAMQPWorkerTest do
  use ChattermillReviewService.DataCase, async: false
  import ChattermillReviewService.Factory

  alias ChattermillReviewService.{ReviewAMQPWorker, Reviews}

  setup_all do
    System.put_env("AMQP_QUEUE", "chattermill_review_test")

    on_exit(fn -> System.delete_env("AMQP_QUEUE") end)
  end

  describe "publish_review/1" do
    test "returns the encoded message when valid data" do
      {:noreply, channel} = ReviewAMQPWorker.handle_continue(:connect, nil)

      insert(:theme, id: 6194)

      attrs = %{
        comment: "excellent message published",
        themes: [
          %{
            theme_id: 6194,
            sentiment: 0
          }
        ],
        created_at: "2019-07-18T23:28:36.000Z",
        id: 53_451_294
      }

      assert {:ok, Jason.encode!(attrs)} == ReviewAMQPWorker.publish_review(attrs)

      assert AMQP.Queue.empty?(channel, "chattermill_review_test")
    end

    test "returns error with reason when invalid data" do
      Logger.remove_backend(:console)
      on_exit(fn -> Logger.add_backend(:console) end)

      start_supervised(ReviewAMQPWorker)

      assert {:error, "invalid byte 0xFF in <<255>>", <<255>>} ==
               ReviewAMQPWorker.publish_review("\xFF")
    end
  end

  describe "handle_continue/2" do
    test "returns an amqp connection" do
      assert {
               :noreply,
               %AMQP.Channel{conn: %AMQP.Connection{pid: _conn_pid}, pid: _chann_pid} = channel
             } = ReviewAMQPWorker.handle_continue(:connect, nil)

      assert {:ok, %{consumer_count: _, message_count: _, queue: "chattermill_review_test"}} =
               AMQP.Queue.status(channel, "chattermill_review_test")

      assert {:ok, %{message_count: 0}} = AMQP.Queue.delete(channel, "chattermill_review_test")
    end

    test "returns a timeout when connection is refused" do
      Logger.remove_backend(:console)
      System.put_env("AMQP_HOST", "foobar")
      on_exit(fn -> System.put_env("AMQP_HOST", "localhost") end)
      assert {:noreply, nil, 10_000} == ReviewAMQPWorker.handle_continue(:connect, nil)
      Logger.add_backend(:console)
    end
  end

  describe "handle_info/2" do
    setup do
      Logger.remove_backend(:console)
      on_exit(fn -> Logger.add_backend(:console) end)

      :ok
    end

    test "handling :timeout message returns a continue message" do
      assert {:noreply, nil, {:continue, :connect}} == ReviewAMQPWorker.handle_info(:timeout, nil)
    end

    test "handling connection process :DOWN message stops the server so the supervisor restarts it" do
      assert {:stop, {:connection_lost, "'cos I said so!"}, nil} ==
               ReviewAMQPWorker.handle_info({:DOWN, nil, :process, nil, "'cos I said so!"}, nil)
    end

    test "handling :basic_consume_ok message returns the channel" do
      assert {:noreply, "my channel"} ==
               ReviewAMQPWorker.handle_info({:basic_consume_ok, nil}, "my channel")
    end

    test "handling :basic_cancel message returns an instruction to stop the server" do
      assert {:stop, :normal, "my channel"} ==
               ReviewAMQPWorker.handle_info({:basic_cancel, nil}, "my channel")
    end

    test "handling :basic_cancel_ok message returns the channel" do
      assert {:noreply, "my channel"} ==
               ReviewAMQPWorker.handle_info({:basic_cancel_ok, nil}, "my channel")
    end

    test "handling :basic_deliver message returns the channel" do
      insert(:theme, id: 6194)
      {:noreply, channel} = ReviewAMQPWorker.handle_continue(:connect, nil)

      attrs = %{
        comment: "excellent message published",
        themes: [
          %{
            theme_id: 6194,
            sentiment: 0
          }
        ],
        created_at: "2019-07-18T23:28:36.000Z",
        id: 53_451_294
      }

      assert {:noreply, channel} ==
               ReviewAMQPWorker.handle_info(
                 {:basic_deliver, Jason.encode!(attrs), %{delivery_tag: 1, redelivered: false}},
                 channel
               )

      assert %{id: 53_451_294, comment: "excellent message published"} =
               Reviews.get_review!(53_451_294)
    end

    test "handling :basic_deliver with invalid message returns the channel" do
      {:noreply, channel} = ReviewAMQPWorker.handle_continue(:connect, nil)

      assert {:noreply, channel} ==
               ReviewAMQPWorker.handle_info(
                 {:basic_deliver, "My invalid message content",
                  %{delivery_tag: 1, redelivered: false}},
                 channel
               )
    end
  end
end
