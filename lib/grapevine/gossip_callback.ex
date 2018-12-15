defmodule Grapevine.GossipCallback do
  @moduledoc """
  Callback module for Gossip

  Plugs into the gossip network.
  """

  require Logger

  alias Backbone.Games
  alias Backbone.Sync
  alias Grapevine.Tells

  @behaviour Gossip.Client.Core
  @behaviour Gossip.Client.Players
  @behaviour Gossip.Client.Tells
  @behaviour Gossip.Client.Games

  @impl true
  def user_agent(), do: Grapevine.version()

  @impl true
  def channels(), do: []

  @impl true
  def players(), do: ["system"]

  @impl true
  def authenticated() do
    Sync.trigger_sync()
  end

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
  def player_update(game_name, _player_names) do
    with {:ok, game} <- Games.get_by_name(game_name) do
      Games.touch_online(game)
    end
  end

  @impl true
  def tell_receive(from_game, from_player, to_player, message) do
    Tells.tell_received(from_game, from_player, to_player, message)
  end

  @impl true
  def game_update(_game), do: :ok

  @impl true
  def game_connect(game_name) do
    with {:ok, game} <- Games.get_by_name(game_name) do
      Games.touch_online(game)
    end
  end

  @impl true
  def game_disconnect(_game), do: :ok

  defmodule SystemCallback do
    @moduledoc """
    System callback module, the application level events
    """

    @behaviour Gossip.Client.SystemCallback

    alias Backbone.Channels
    alias Backbone.Sync

    def authenticated(state) do
      channels = Enum.map(Channels.all(), &(&1.name))
      {:ok, %{state | channels: channels}}
    end

    def process(state, event = %{"event" => "sync/channels"}) do
      Sync.sync_channels(state, event)

      {:ok, state}
    end

    def process(state, event = %{"event" => "sync/events"}) do
      Sync.sync_events(event)

      {:ok, state}
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
