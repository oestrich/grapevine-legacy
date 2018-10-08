defmodule Grapevine.GossipCallback do
  @moduledoc """
  Callback module for Gossip

  Plugs into the gossip network.
  """

  require Logger

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
  def tell_received(_from_game, _from_player, _to_player, _message), do: :ok

  defmodule SystemCallback do
    @moduledoc """
    System callback module, the application level events
    """

    @behaviour Gossip.Client.SystemCallback

    alias Grapevine.Channels

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

    def process(state, event) do
      Logger.debug(fn ->
        "Received a new event - #{inspect(event)}"
      end)

      {:ok, state}
    end
  end
end
