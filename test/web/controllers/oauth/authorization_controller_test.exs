defmodule Web.Oauth.AuthorizationControllerTest do
  use Web.AuthConnCase

  alias Grapevine.Authorizations

  setup [:with_game]

  describe "authorizing a connection" do
    test "with appropriate connection", %{conn: conn, user: user, game: game} do
      authorization = create_authorization(user, game)

      conn = patch(conn, authorization_path(conn, :update), authorization: %{id: authorization.id, allow: "true"})

      assert redirected_to(conn) == "https://example.com/oauth/callback?code=#{authorization.code}&state=my%2Bstate"
    end
  end

  describe "denying a connection" do
    test "with appropriate connection", %{conn: conn, user: user, game: game} do
      authorization = create_authorization(user, game)

      conn = patch(conn, authorization_path(conn, :update), authorization: %{id: authorization.id, allow: "false"})

      assert redirected_to(conn) == "https://example.com/oauth/callback?error=access_denied&state=my%2Bstate"
    end
  end

  def with_game(_) do
    %{game: cache_game()}
  end

  def create_authorization(user, game) do
    {:ok, authorization} = Authorizations.start_auth(user, game, %{
      state: "my+state",
      redirect_uri: "https://example.com/oauth/callback",
    })
    authorization
  end
end
