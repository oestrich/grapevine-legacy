defmodule Grapevine.AccountsTest do
  use Grapevine.DataCase

  alias Grapevine.Accounts

  describe "registering a new account" do
    test "successful" do
      {:ok, user} = Accounts.register(%{
        username: "user",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password",
      })

      assert user.email == "user@example.com"
      assert user.password_hash
    end
  end

  describe "verifying a password" do
    setup do
      %{user: create_user(%{password: "password"})}
    end

    test "when valid", %{user: user} do
      assert {:ok, _user} = Accounts.validate_login(user.email, "password")
    end

    test "when invalid", %{user: user} do
      assert {:error, :invalid} = Accounts.validate_login(user.email, "passw0rd")
    end

    test "when bad email" do
      assert {:error, :invalid} = Accounts.validate_login("unknown@email.com", "passw0rd")
    end
  end
end
