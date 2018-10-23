defmodule Grapevine.Games do
  @moduledoc """
  Check if a game is online or not
  """

  @doc """
  Check if a game is online or not
  """
  def game_online?(game) do
    Gossip.Games.game_online?(game.short_name)
  end
end
