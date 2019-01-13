defmodule Web.PageController do
  use Web, :controller

  alias Web.Game

  def index(conn, _params) do
    conn
    |> assign(:highlighted_game, Game.highlighted_game())
    |> assign(:open_graph_title, "Grapevine")
    |> assign(:open_graph_description, "MUD Player Network. Part of Gossip.")
    |> render("index.html")
  end

  def media(conn, _params) do
    render(conn, "media.html")
  end
end
