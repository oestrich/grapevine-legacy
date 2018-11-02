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
    |> put_change(:game_id, game.id)
    |> put_change(:code, UUID.uuid4())
  end

  def authorize_changeset(struct) do
    struct
    |> change()
    |> put_change(:active, true)
  end
end
