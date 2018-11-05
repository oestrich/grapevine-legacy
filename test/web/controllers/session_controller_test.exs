defmodule Web.SessionControllerTest do
  use Web.ConnCase

  setup [:with_user]

  describe "signing in" do
    test "successfully", %{conn: conn, user: user} do
      conn = post(conn, session_path(conn, :create), user: %{email: user.email, password: "password"})

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "with a last known page", %{conn: conn, user: user} do
      conn = get(conn, authorization_path(conn, :new, client_id: "id"))

      conn = post(conn, session_path(conn, :create), user: %{email: user.email, password: "password"})

      assert redirected_to(conn) == authorization_path(conn, :new, client_id: "id")
    end
  end

  def with_user(_) do
    %{user: create_user(%{email: "user@example.com", password: "password"})}
  end
end
