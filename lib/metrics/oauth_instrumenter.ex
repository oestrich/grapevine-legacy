defmodule Metrics.OAuthInstrumenter do
  @moduledoc """
  OAuth 2.0 instrumenter for Prometheus and Telemetry
  """

  use Prometheus.Metric

  require Logger

  @doc false
  def setup() do
    Counter.declare(
      name: :grapevine_oauth_start_count,
      help: "Total count of someone starting authorization"
    )

    Counter.declare(
      name: :grapevine_oauth_authorized_count,
      help: "Total number of authorized connections"
    )

    Counter.declare(
      name: :grapevine_oauth_denied_count,
      help: "Total number of denied connections"
    )

    Counter.declare(
      name: :grapevine_oauth_invalid_grant_count,
      help: "Total number of failures to create a new access token"
    )

    Counter.declare(
      name: :grapevine_oauth_token_created_count,
      help: "Total number of access tokens successfully created"
    )

    Enum.each([:start, :authorized, :denied, :invalid_grant, :create_token], fn kind ->
      Telemetry.attach("oauth-prometheus-#{kind}", [:web, :oauth, kind], __MODULE__, :handle_event, nil)
    end)
  end

  def handle_event([:web, :oauth, :start], _value, %{user_id: user_id, game_id: game_id}, _config) do
    Logger.debug(fn ->
      "Starting OAuth for user: #{user_id}, game: #{game_id}"
    end, type: :oauth)

    Counter.inc(name: :grapevine_oauth_start_count)
  end

  def handle_event([:web, :oauth, :authorized], _value, metadata, _config) do
    Logger.debug(fn ->
      "OAuth connection authorized user: #{metadata.user_id}, game: #{metadata.game_id}"
    end, type: :oauth)

    Counter.inc(name: :grapevine_oauth_authorized_count)
  end

  def handle_event([:web, :oauth, :denied], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_oauth_denied_count)
  end

  def handle_event([:web, :oauth, :invalid_grant], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_oauth_invalid_grant_count)
  end

  def handle_event([:web, :oauth, :create_token], _value, _metadata, _config) do
    Counter.inc(name: :grapevine_oauth_token_created_count)
  end
end
