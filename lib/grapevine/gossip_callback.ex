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

  defmodule SystemCallback do
    @moduledoc """
    System callback module, the application level events
    """

    @behaviour Gossip.Client.SystemCallback

    alias Backbone.Channels
    alias Backbone.Games

    def process(state, event = %{"event" => "sync/channels"}) do
      with {:ok, payload} <- Map.fetch(event, "payload"),
           {:ok, channels} <- Map.fetch(payload, "channels") do
        Channels.cache_remote(channels)

        channels = Enum.reduce(channels, state.channels, fn channel, channels ->
          [channel["name"] | channels]
        end)
        channels = Enum.uniq(channels)

        {:ok, %{state | channels: channels}}
      else
        _ ->
          {:ok, state}
      end
    end

    def process(state, event = %{"event" => "sync/games"}) do
      with {:ok, payload} <- Map.fetch(event, "payload"),
           {:ok, games} <- Map.fetch(payload, "games") do
        Games.cache_remote(games)
      end

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
