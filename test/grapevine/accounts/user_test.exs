defmodule Grapevine.Accounts.UserTest do
  use Grapevine.DataCase

  alias Grapevine.Accounts.User

  setup do
    %{user: %User{}}
  end

  describe "validations" do
    test "trims username and email", %{user: user} do
      changeset = User.changeset(user, %{
        username: "user ",
        email: "user@example.com ",
      })

      assert changeset.changes[:username] == "user"
      assert changeset.changes[:email] == "user@example.com"
    end

    test "blocked list of names", %{user: user} do
      changeset = User.changeset(user, %{
        username: "admin",
      })

      assert Keyword.has_key?(changeset.errors, :username)
    end

    test "matches the blocked name even different case", %{user: user} do
      changeset = User.changeset(user, %{
        username: "AdMiN",
      })

      assert Keyword.has_key?(changeset.errors, :username)
    end

    test "validates username characters", %{user: user} do
      changeset = User.changeset(user, %{username: "user@game"})
      assert Keyword.has_key?(changeset.errors, :username)

      changeset = User.changeset(user, %{username: "user-name"})
      refute Keyword.has_key?(changeset.errors, :username)
    end

    test "validates username length", %{user: user} do
      changeset = User.changeset(user, %{username: "user"})
      refute Keyword.has_key?(changeset.errors, :username)

      changeset = User.changeset(user, %{username: "this-is-a-very-long-username-who-wants-it-this-long"})
      assert Keyword.has_key?(changeset.errors, :username)
    end
  end
end
