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
        :telemetry.execute([:grapevine, :accounts, :session, :login], 1)

        conn
        |> put_flash(:info, "You have signed in.")
        |> put_session(:user_token, user.token)
        |> after_sign_in_redirect()

      {:error, :invalid} ->
        conn
        |> put_flash(:error, "Your email or password is invalid")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    :telemetry.execute([:grapevine, :accounts, :session, :logout], 1)

    conn
    |> clear_session()
    |> redirect(to: page_path(conn, :index))
  end

  @doc """
  Redirect to the last seen page after being asked to sign in

  Or the home page
  """
  def after_sign_in_redirect(conn) do
    case get_session(conn, :last_path) do
      nil ->
        conn |> redirect(to: page_path(conn, :index))

      path ->
        conn
        |> put_session(:last_path, nil)
        |> redirect(to: path)
    end
  end
end
