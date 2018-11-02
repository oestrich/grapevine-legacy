defmodule Grapevine.Authorizations do
  @moduledoc """
  Authorize remote logins
  """

  alias Backbone.Games
  alias Grapevine.Authorizations.AccessToken
  alias Grapevine.Authorizations.Authorization
  alias Grapevine.Repo

  @doc """
  Start authorization

  Creates an authorization record
  """
  def start_auth(user, game, params) do
    with {:ok, redirect_uri} <- Map.fetch(params, "redirect_uri") do
      opts = [
        user_id: user.id,
        game_id: game.id,
        redirect_uri: redirect_uri,
        active: true,
      ]

      case Repo.get_by(Authorization, opts) do
        nil ->
          create_authorization(user, game, params)

        authorization ->
          {:ok, authorization}
      end
    else
      _ ->
        create_authorization(user, game, params)
    end
  end

  defp create_authorization(user, game, params) do
    user
    |> Ecto.build_assoc(:authorizations)
    |> Authorization.create_changeset(game, params)
    |> Repo.insert()
  end

  @doc """
  Get a user's authorization record
  """
  def get(user, id) do
    case Repo.get_by(Authorization, user_id: user.id, id: id) do
      nil ->
        {:error, :not_found}

      authorization ->
        {:ok, authorization}
    end
  end

  def get_token(token) do
    with {:ok, token} <- Ecto.UUID.cast(token) do
      case Repo.get_by(AccessToken, access_token: token) do
        nil ->
          {:error, :not_found}

        access_token ->
          {:ok, Repo.preload(access_token, [authorization: [:user]])}
      end
    else
      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Authorize an authorization

  Marks it as active
  """
  def authorize(authorization) do
    authorization
    |> Authorization.authorize_changeset()
    |> Repo.update()
  end

  @doc """
  Deny an authorization

  Deletes the authorization record
  """
  def deny(authorization) do
    Repo.delete(authorization)
  end

  @doc """
  Get an authorized redirect uri

  Includes the authorization code
  """
  def authorized_redirect_uri(authorization) do
    uri = URI.parse(authorization.redirect_uri)
    query = URI.encode_query(%{code: authorization.code, state: authorization.state})
    uri = %{uri | query: query}
    {:ok, URI.to_string(uri)}
  end

  @doc """
  Get a denied redirect uri
  """
  def denied_redirect_uri(authorization) do
    uri = URI.parse(authorization.redirect_uri)
    query = URI.encode_query(%{error: :access_denied, state: authorization.state})
    uri = %{uri | query: query}
    {:ok, URI.to_string(uri)}
  end

  @doc """
  Create an access token
  """
  def create_token(client_id, redirect_uri, code) do
    with {:ok, client_id} <- Ecto.UUID.cast(client_id),
         {:ok, game} <- Games.get_by(client_id: client_id),
         {:ok, code} <- Ecto.UUID.cast(code) do
      case Repo.get_by(Authorization, game_id: game.id, redirect_uri: redirect_uri, code: code) do
        nil ->
          {:error, :invalid_grant}

        authorization ->
          create_token(authorization)
      end
    else
      _ ->
        {:error, :invalid_grant}
    end
  end

  @doc false
  def create_token(authorization = %Authorization{}) do
    authorization
    |> Ecto.build_assoc(:access_tokens)
    |> AccessToken.create_changeset()
    |> Repo.insert()
  end

  @doc """
  Validate a token

  A token is valid if:
  - within expiration time
  - authorization is active
  """
  def valid_token?(access_token) do
    access_token = Repo.preload(access_token, [:authorization])

    case access_token.authorization.active do
      false ->
        false

      true ->
        valid_til = access_token.inserted_at |> Timex.shift(seconds: access_token.expires_in)
        Timex.before?(Timex.now(), valid_til)
    end
  end
end
