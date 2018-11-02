defmodule Web.UserControllerTest do
  use Web.ConnCase

  alias Grapevine.Authorizations

  describe "view yourself" do
    test "correct token", %{conn: conn} do
      user = create_user()
      game = cache_game()

      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })
      {:ok, authorization} = Authorizations.authorize(authorization)

      {:ok, access_token} = Authorizations.create_token(game.client_id, authorization.redirect_uri, authorization.code)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{access_token.access_token}")
        |> put_req_header("accept", "application/json")

      conn = get(conn, user_path(conn, :show))

      assert json_response(conn, 200)
    end

    test "bad token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{UUID.uuid4()}")
        |> put_req_header("accept", "application/json")

      conn = get(conn, user_path(conn, :show))

      assert json_response(conn, 401)
    end
  end
end
