defmodule Web.UserController do
  use Web, :controller

  def show(conn, _params) do
    conn
    |> assign(:user, conn.assigns.current_user)
    |> render("show.json")
  end
end
