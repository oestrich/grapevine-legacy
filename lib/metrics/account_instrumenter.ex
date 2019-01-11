defmodule Metrics.AccountInstrumenter do
  @moduledoc """
  Accounts instrumenter for Prometheus and Telemetry
  """

  use Prometheus.Metric

  require Logger

  @doc false
  def setup() do
    Counter.declare(
      name: :grapevine_account_create_total,
      help: "Total count of someone creating an account"
    )

    Counter.declare(
      name: :grapevine_account_login_total,
      help: "Total number of logins"
    )

    Counter.declare(
      name: :grapevine_account_logout_total,
      help: "Total number of logouts"
    )

    events = [
      [:grapevine, :accounts, :create],
      [:grapevine, :accounts, :session, :login],
      [:grapevine, :accounts, :session, :logout],
    ]

    :telemetry.attach_many("grapevine-accounts", events, &handle_event/4, nil)
  end

  def handle_event([:grapevine, :accounts, :create], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_account_create_total)
  end

  def handle_event([:grapevine, :accounts, :session, :login], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_account_login_total)
  end

  def handle_event([:grapevine, :accounts, :session, :logout], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_account_logout_total)
  end
end
