defmodule Web.RegistrationControllerTest do
  use Web.ConnCase

  describe "signing in" do
    test "successfully", %{conn: conn} do
      params = %{
        username: "user",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password",
      }

      conn = post(conn, registration_path(conn, :create), user: params)

      assert redirected_to(conn) == page_path(conn, :index)
    end

    test "with a last known page", %{conn: conn} do
      conn = get(conn, authorization_path(conn, :new, client_id: "id"))

      params = %{
        username: "user",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password",
      }

      conn = post(conn, registration_path(conn, :create), user: params)

      assert redirected_to(conn) == authorization_path(conn, :new, client_id: "id")
    end
  end
end
