defmodule Grapevine.TestHelpers do
  alias Grapevine.Accounts

  def create_user(attributes \\ %{}) do
    attributes = Map.merge(%{
      username: "admin",
      email: "admin@example.com",
      password: "password",
      password_confirmation: "password",
    }, attributes)

    {:ok, user} = Accounts.register(attributes)

    user
  end
end
