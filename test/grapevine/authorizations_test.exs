defmodule Grapevine.AuthorizationsTest do
  use Grapevine.DataCase

  alias Grapevine.Authorizations
  alias Grapevine.Authorizations.Authorization

  describe "starting to authenticate" do
    setup [:with_user, :with_game]

     test "successful", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      assert authorization.state == "my+state"
      assert authorization.redirect_uri == "https://example.com/oauth/callback"
      assert authorization.scopes == []
    end

    test "reuses authorizations if one is already active", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })
      {:ok, authorization} = Authorizations.authorize(authorization)

      {:ok, new_authorization} = Authorizations.start_auth(user, game, %{
        "state" => "my+state",
        "redirect_uri" => "https://example.com/oauth/callback",
      })

      assert new_authorization.id == authorization.id
    end

    test "missing params", %{user: user, game: game} do
      {:error, changeset} = Authorizations.start_auth(user, game, %{
        state: "my+state",
      })

      assert changeset.errors[:redirect_uri]
    end
  end

  describe "get a user's authorization" do
    setup [:with_user, :with_game]

    test "scoped to the user", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      assert {:ok, _authorization} = Authorizations.get(user, authorization.id)

      user = create_user(%{username: "other", email: "other@example.com"})
      assert {:error, :not_found} = Authorizations.get(user, authorization.id)
    end
  end

  describe "mark an authorization as allowed" do
    setup [:with_user, :with_game]

    test "sets authorization to active", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:ok, authorization} = Authorizations.authorize(authorization)

      assert authorization.active
    end
  end

  describe "mark an authorization as denied" do
    setup [:with_user, :with_game]

    test "deletes the authorization", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:ok, authorization} = Authorizations.deny(authorization)

      assert {:error, :not_found} = Authorizations.get(user, authorization.id)
    end
  end

  describe "redirect uris" do
    test "authorized uri" do
      authorization = %Authorization{
        code: "code",
        redirect_uri: "https://example.com/oauth/callback",
        state: "my+state"
      }

      {:ok, uri} = Authorizations.authorized_redirect_uri(authorization)
      assert uri == "https://example.com/oauth/callback?code=code&state=my%2Bstate"
    end

    test "denied uri" do
      authorization = %Authorization{
        code: "code",
        redirect_uri: "https://example.com/oauth/callback",
        state: "my+state"
      }

      {:ok, uri} = Authorizations.denied_redirect_uri(authorization)
      assert uri == "https://example.com/oauth/callback?error=access_denied&state=my%2Bstate"
    end
  end

  describe "create an access token for an authorization" do
    setup [:with_user, :with_game]

    test "create a token", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:ok, access_token} = Authorizations.create_token(game.client_id, authorization.redirect_uri, authorization.code)

      assert access_token.access_token
    end

    test "invalid client id", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:error, :invalid_grant} = Authorizations.create_token("invalid", authorization.redirect_uri, authorization.code)
    end

    test "invalid redirect uri", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:error, :invalid_grant} = Authorizations.create_token(game.client_id, "redirect", authorization.code)
    end

    test "invalid code", %{user: user, game: game} do
      {:ok, authorization} = Authorizations.start_auth(user, game, %{
        state: "my+state",
        redirect_uri: "https://example.com/oauth/callback",
      })

      {:error, :invalid_grant} = Authorizations.create_token(game.client_id, authorization.redirect_uri, "code")
    end
  end

  describe "access token is valid" do
    setup [:with_user, :with_game, :with_token]

    test "is valid", %{access_token: access_token} do
      assert Authorizations.valid_token?(access_token)
    end

    test "after expiration", %{access_token: access_token} do
      yesterday = Timex.now() |> Timex.shift(days: -1)
      access_token = %{access_token | inserted_at: yesterday}

      refute Authorizations.valid_token?(access_token)
    end

    test "authorization is not valid", %{authorization: authorization, access_token: access_token} do
      authorization
      |> Ecto.Changeset.change(%{active: false})
      |> Repo.update!()

      refute Authorizations.valid_token?(access_token)
    end
  end

  def with_user(_) do
    %{user: create_user()}
  end

  def with_game(_) do
    %{game: cache_game()}
  end

  def with_token(%{user: user, game: game}) do
    {:ok, authorization} = Authorizations.start_auth(user, game, %{
      state: "my+state",
      redirect_uri: "https://example.com/oauth/callback",
    })

    {:ok, authorization} = Authorizations.authorize(authorization)
    {:ok, access_token} = Authorizations.create_token(authorization)

    %{authorization: authorization, access_token: access_token}
  end
end
