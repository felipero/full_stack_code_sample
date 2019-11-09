{:ok, _} = Application.ensure_all_started(:ex_machina)

Supervisor.terminate_child(
  ChattermillReviewService.Supervisor,
  ChattermillReviewService.ReviewAMQPWorker
)

Supervisor.delete_child(
  ChattermillReviewService.Supervisor,
  ChattermillReviewService.ReviewAMQPWorker
)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(ChattermillReviewService.Repo, :manual)
