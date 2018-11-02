defmodule Web.Plugs.VerifyScopesTest do
  use Web.ConnCase

  alias Web.Plugs.VerifyScopes

  describe "denies requests with missing scopes" do
    test "scope is present passes through", %{conn: conn} do
      conn = assign(conn, :current_scopes, ["profile"])
      conn = VerifyScopes.call(conn, [scope: "profile"])
      refute conn.status
    end

    test "halts requests with missing scopes", %{conn: conn} do
      conn = assign(conn, :current_scopes, ["profile"])
      conn = VerifyScopes.call(conn, [scope: "email"])
      assert conn.status == 401
    end
  end
end
