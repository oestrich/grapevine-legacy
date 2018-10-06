defmodule Grapevine.TestHelpers do
  @moduledoc false

  alias Grapevine.Accounts

  def create_user(attributes \\ %{}) do
    attributes = Map.merge(%{
      username: "user",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
    }, attributes)

    {:ok, user} = Accounts.register(attributes)

    user
  end
end
