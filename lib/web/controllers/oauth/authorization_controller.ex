defmodule Web.Oauth.AuthorizationController do
  use Web, :controller

  plug(Web.Plugs.FetchGame when action in [:new])

  alias Grapevine.Authorizations

  def new(conn, params) do
    %{current_user: user, client_game: game} = conn.assigns

    with {:ok, authorization} <- Authorizations.start_auth(user, game, params) do
      conn
      |> assign(:authorization, authorization)
      |> render("new.html")
    end
  end

  def update(conn, %{"authorization" => %{"id" => id, "allow" => "true"}}) do
    %{current_user: user} = conn.assigns

    with {:ok, authorization} <- Authorizations.get(user, id),
         {:ok, authorization} <- Authorizations.authorize(authorization),
         {:ok, uri} <- Authorizations.authorized_redirect_uri(authorization) do
      conn |> redirect(external: uri)
    else
      _ ->
        conn
        |> put_flash(:error, "Unknown issue authenticating. Please try again")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def update(conn, %{"authorization" => %{"id" => id, "allow" => "false"}}) do
    %{current_user: user} = conn.assigns

    with {:ok, authorization} <- Authorizations.get(user, id),
         {:ok, uri} <- Authorizations.denied_redirect_uri(authorization),
         {:ok, _authorization} <- Authorizations.deny(authorization) do
      conn |> redirect(external: uri)
    else
      _ ->
        conn
        |> put_flash(:error, "Unknown issue authenticating. Please try again")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
