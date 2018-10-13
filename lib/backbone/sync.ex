defmodule Backbone.Sync do
  @moduledoc """
  Sync remote models to the local db
  """

  alias Backbone.Channels
  alias Backbone.Games

  def sync_channels(state, event) do
    with {:ok, payload} <- Map.fetch(event, "payload"),
         {:ok, channels} <- Map.fetch(payload, "channels") do
      Channels.cache_remote(channels)

      channels =
        Enum.reduce(channels, state.channels, fn channel, channels ->
          [channel["name"] | channels]
        end)

      channels = Enum.uniq(channels)

      {:ok, %{state | channels: channels}}
    else
      _ ->
        {:ok, state}
    end
  end

  def sync_games(event) do
    with {:ok, payload} <- Map.fetch(event, "payload"),
         {:ok, games} <- Map.fetch(payload, "games") do
      Games.cache_remote(games)
    end
  end
end
