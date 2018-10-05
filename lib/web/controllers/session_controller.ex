defmodule Web.SessionController do
  use Web, :controller

  alias Grapevine.Accounts

  def new(conn, _params) do
    changeset = Accounts.new()

    conn
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.validate_login(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You have signed in.")
        |> put_session(:user_token, user.token)
        |> redirect(to: page_path(conn, :index))

      {:error, :invalid} ->
        conn
        |> put_flash(:error, "Your email or password is invalid")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: page_path(conn, :index))
  end
end
