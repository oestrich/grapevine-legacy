defmodule Web.Game do
  @moduledoc """
  Helpers for games in the web view
  """

  alias Grapevine.Games

  @doc """
  Chose a random game that is online and has a home page
  """
  def highlighted_game() do
    Games.all(online_only: true)
    |> Enum.filter(&(&1.homepage_url != nil))
    |> Enum.shuffle()
    |> List.first()
  end
end
