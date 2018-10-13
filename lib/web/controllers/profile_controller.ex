defmodule Web.ProfileController do
  use Web, :controller

  alias Grapevine.Accounts

  action_fallback(Web.FallbackController)

  def show(conn, %{"id" => username}) do
    username = URI.decode_www_form(username)

    with {:ok, user} <- Accounts.get_by_username(username) do
      conn
      |> assign(:user, user)
      |> render("show.html")
    end
  end
end
