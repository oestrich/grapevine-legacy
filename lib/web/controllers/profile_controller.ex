defmodule Web.ProfileController do
  use Web, :controller

  alias Grapevine.Accounts
  alias Web.LayoutView

  action_fallback(Web.FallbackController)

  def show(conn, %{"id" => username}) do
    username = URI.decode_www_form(username)

    with {:ok, user} <- Accounts.get_by_username(username) do
      conn
      |> assign(:user, user)
      |> assign(:title, "#{user.username} - Grapevine Profile")
      |> assign(:open_graph_title, user.username)
      |> assign(:open_graph_url, profile_path(conn, :show, LayoutView.profile_id(user)))
      |> render("show.html")
    end
  end
end
