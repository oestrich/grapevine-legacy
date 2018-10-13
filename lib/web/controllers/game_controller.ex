defmodule Web.GameController do
  use Web, :controller

  alias Grapevine.Games

  action_fallback(Web.FallbackController)

  def index(conn, _params) do
    conn
    |> assign(:games, Games.all())
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    with {:ok, game} <- Games.get(id, display: true) do
      conn
      |> assign(:game, game)
      |> render("show.html")
    end
  end
end
