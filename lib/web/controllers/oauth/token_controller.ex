defmodule Web.Oauth.TokenController do
  use Web, :controller

  alias Grapevine.Authorizations
  alias Web.ErrorView

  def create(conn, params = %{"grant_type" => "authorization_code"}) do
    with {:ok, code} <- Map.fetch(params, "code"),
         {:ok, client_id} <- Map.fetch(params, "client_id"),
         {:ok, redirect_uri} <- Map.fetch(params, "redirect_uri"),
         {:ok, access_token} <- Authorizations.create_token(client_id, redirect_uri, code) do
      conn
      |> assign(:access_token, access_token)
      |> render("token.json")
    else
      _ ->
        render(conn, ErrorView, "500.json")
    end
  end
end
