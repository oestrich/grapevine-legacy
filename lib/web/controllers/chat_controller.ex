defmodule Web.ChatController do
  use Web, :controller

  alias Grapevine.Channels

  def index(conn, _params) do
    conn
    |> assign(:channels, Channels.all())
    |> render("index.html")
  end
end
