defmodule Grapevine.Application do
  @moduledoc false

  use Application

  @report_errors Application.get_env(:grapevine, :errors)[:report]

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children = [
      {Grapevine.Repo, []},
      {Web.Endpoint, []},
      {Grapevine.Tells, []}
    ]

    if @report_errors do
      :ok = :error_logger.add_report_handler(Sentry.Logger)
    end

    Metrics.Setup.setup()

    opts = [strategy: :one_for_one, name: Grapevine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
