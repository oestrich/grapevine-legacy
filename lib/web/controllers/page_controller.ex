defmodule Web.PageController do
  use Web, :controller

  alias Web.Game

  def index(conn, _params) do
    conn
    |> assign(:highlighted_game, Game.highlighted_game())
    |> render("index.html")
  end

  def media(conn, _params) do
    render(conn, "media.html")
  end
end
