defmodule Grapevine.GossipCallback do
  @moduledoc """
  Callback module for Gossip

  Plugs into the gossip network.
  """

  require Logger

  alias Grapevine.Tells

  @behaviour Gossip.Client

  @impl true
  def user_agent(), do: Grapevine.version()

  @impl true
  def channels(), do: []

  @impl true
  def players(), do: ["system"]

  @impl true
  def message_broadcast(message) do
    Logger.info(inspect(message))

    Web.Endpoint.broadcast("chat:#{message.channel}", "broadcast", Map.from_struct(message))
  end

  @impl true
  def player_sign_in(_game_name, _player_name), do: :ok

  @impl true
  def player_sign_out(_game_name, _player_name), do: :ok

  @impl true
  def players_status(_game_name, _player_names), do: :ok

  @impl true
  def tell_received(from_game, from_player, to_player, message) do
    Tells.tell_received(from_game, from_player, to_player, message)
  end

  @impl true
  def games_status(_game), do: :ok

  defmodule SystemCallback do
    @moduledoc """
    System callback module, the application level events
    """

    @behaviour Gossip.Client.SystemCallback

    alias Backbone.Sync

    def process(state, event = %{"event" => "sync/channels"}) do
      Sync.sync_channels(state, event)
    end

    def process(state, event = %{"event" => "sync/games"}) do
      Sync.sync_games(event)

      {:ok, state}
    end

    def process(state, event) do
      Logger.debug(fn ->
        "Received a new event - #{inspect(event)}"
      end)

      {:ok, state}
    end
  end
end
