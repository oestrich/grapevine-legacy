defmodule Web.AchievementController do
  use Web, :controller

  alias Backbone.Achievements
  alias Backbone.Games

  def index(conn, %{"game_id" => game_name}) do
    with {:ok, game} <- Games.get_by_name(game_name) do
      conn
      |> assign(:game, game)
      |> assign(:achievements, Achievements.all(game))
      |> assign(:title, "#{game.name} Achievements - Grapevine")
      |> assign(:open_graph_title, "#{game.name} Achievements")
      |> assign(:open_graph_url, game_achievement_url(conn, :index, game.short_name))
      |> render("index.html")
    end
  end
end
