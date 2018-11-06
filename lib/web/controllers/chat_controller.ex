defmodule Web.ChatController do
  use Web, :controller

  alias Backbone.Channels

  def index(conn, _params) do
    conn
    |> assign(:channels, Channels.all())
    |> assign(:title, "Grapevine Chat")
    |> render("index.html")
  end
end
