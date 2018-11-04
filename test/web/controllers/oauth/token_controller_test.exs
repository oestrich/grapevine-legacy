defmodule Web.Oauth.TokenControllerTest do
  use Web.AuthConnCase

  alias Grapevine.Authorizations

  setup [:with_game, :with_authorization]

  describe "swap a code for a token" do
    test "code type", %{conn: conn, game: game, authorization: authorization} do
      {:ok, authorization} = Authorizations.authorize(authorization)

      params = %{
        client_id: game.client_id,
        code: authorization.code,
        grant_type: "authorization_code",
        redirect_uri: authorization.redirect_uri,
      }

      conn = post(conn, token_path(conn, :create), params)

      assert json_response(conn, 200)["access_token"]
    end

    test "missing params", %{conn: conn, game: game, authorization: authorization} do
      {:ok, authorization} = Authorizations.authorize(authorization)

      params = %{
        client_id: game.client_id,
        code: authorization.code,
        grant_type: "authorization_code",
      }

      conn = post(conn, token_path(conn, :create), params)

      assert json_response(conn, 400)["error"]
    end
  end

  def with_game(_) do
    %{game: cache_game()}
  end

  def with_authorization(%{user: user, game: game}) do
    %{authorization: create_authorization(user, game)}
  end
end
