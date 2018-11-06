defmodule Web.GameController do
  use Web, :controller

  alias Backbone.Games

  action_fallback(Web.FallbackController)

  def index(conn, _params) do
    conn
    |> assign(:games, Games.all())
    |> assign(:open_graph_title, "Games on Grapevine")
    |> assign(:open_graph_description, "View a listing of games that are on the Grapevine and Gossip network.")
    |> assign(:open_graph_url, game_url(conn, :index))
    |> render("index.html")
  end

  def show(conn, %{"id" => short_name}) do
    with {:ok, game} <- Games.get_by_name(short_name, display: true) do
      conn
      |> assign(:game, game)
      |> render("show.html")
    end
  end
end
