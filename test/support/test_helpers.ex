defmodule Grapevine.TestHelpers do
  @moduledoc false

  alias Backbone.Games
  alias Grapevine.Accounts
  alias Grapevine.Authorizations

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

  def cache_game(attributes \\ %{}) do
    attributes = Map.merge(%{
      "id" => 1,
      "game" => "gossip",
      "display_name" => "Updated",
      "display" => true,
      "allow_character_registration" => true,
      "client_id" => UUID.uuid4(),
      "client_secret" => UUID.uuid4(),
      "redirect_uris" => [
        "https://example.com/oauth/callback"
      ]
    }, attributes)

    Games.cache_remote([attributes])

    {:ok, game} = Games.get_by_name(attributes["game"])
    game
  end

  def create_authorization(user, game) do
    {:ok, authorization} = Authorizations.start_auth(user, game, %{
      "state" => "my+state",
      "redirect_uri" => "https://example.com/oauth/callback",
      "scope" => "profile"
    })
    {:ok, authorization} = Authorizations.authorize(authorization)

    authorization
  end
end
