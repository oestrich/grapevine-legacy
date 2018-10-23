defmodule Grapevine.Games do
  @moduledoc """
  Check if a game is online or not
  """

  @doc """
  Check if a game is online or not
  """
  def game_online?(game) do
    Map.has_key?(Gossip.who(), game.short_name)
  end
end
