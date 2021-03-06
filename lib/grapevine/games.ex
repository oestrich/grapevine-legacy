defmodule Grapevine.Games do
  @moduledoc """
  Check if a game is online or not
  """

  @doc """
  Helper for all games
  """
  def all(opts \\ []), do: Backbone.Games.all(opts)

  @doc """
  Check if a game is online or not
  """
  def game_online?(game) do
    Gossip.Games.game_online?(game.short_name)
  end
end
