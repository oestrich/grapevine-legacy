defmodule Grapevine.Authorizations.Authorization do
  @moduledoc """
  Authorization schema
  """

  use Grapevine.Schema

  alias Backbone.Games.Game
  alias Grapevine.Accounts.User
  alias Grapevine.Authorizations.AccessToken

  schema "authorizations" do
    field(:redirect_uri, :string)
    field(:state, :string)
    field(:scopes, {:array, :string}, default: [])
    field(:code, Ecto.UUID)
    field(:active, :boolean, default: false)

    belongs_to(:user, User)
    belongs_to(:game, Game)

    has_many(:access_tokens, AccessToken)

    timestamps()
  end

  def create_changeset(struct, game, params) do
    struct
    |> cast(params, [:redirect_uri, :state, :scopes])
    |> validate_required([:redirect_uri, :state, :scopes])
    |> validate_redirect_uri()
    |> put_change(:game_id, game.id)
    |> put_change(:code, UUID.uuid4())
  end

  def authorize_changeset(struct) do
    struct
    |> change()
    |> put_change(:active, true)
  end

  defp validate_redirect_uri(changeset) do
    case get_field(changeset, :redirect_uri) do
      nil ->
        changeset

      redirect_uri ->
        uri = URI.parse(redirect_uri)

        changeset
        |> validate_redirect_uri_scheme(uri)
        |> validate_redirect_uri_host(uri)
        |> validate_redirect_uri_path(uri)
        |> validate_redirect_uri_query(uri)
        |> validate_redirect_uri_fragment(uri)
    end
  end

  defp validate_redirect_uri_scheme(changeset, uri) do
    case uri.scheme do
      "https" ->
        changeset

      _ ->
        add_error(changeset, :redirect_uri, "must be https")
    end
  end

  defp validate_redirect_uri_host(changeset, uri) do
    case uri.host do
      nil ->
        add_error(changeset, :redirect_uri, "must be a fully qualified URI")

      _ ->
        changeset
    end
  end

  defp validate_redirect_uri_path(changeset, uri) do
    case uri.path do
      nil ->
        add_error(changeset, :redirect_uri, "must be a fully qualified URI")

      _ ->
        changeset
    end
  end

  defp validate_redirect_uri_query(changeset, uri) do
    case uri.query do
      nil ->
        changeset

      _ ->
        add_error(changeset, :redirect_uri, "must be a fully qualified URI")
    end
  end

  defp validate_redirect_uri_fragment(changeset, uri) do
    case uri.fragment do
      nil ->
        changeset

      _ ->
        add_error(changeset, :redirect_uri, "must be a fully qualified URI")
    end
  end
end
