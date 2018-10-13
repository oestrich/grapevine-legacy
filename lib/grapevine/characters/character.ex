defmodule Grapevine.Characters.Character do
  @moduledoc """
  Character schema
  """

  use Grapevine.Schema

  alias Grapevine.Accounts.User
  alias Backbone.Games.Game

  schema "characters" do
    field(:name, :string)
    field(:state, :string, default: "pending")

    belongs_to(:user, User)
    belongs_to(:game, Game)

    timestamps()
  end

  def create_changeset(struct, game, name) do
    struct
    |> change()
    |> put_change(:game_id, game.id)
    |> put_change(:name, name)
    |> unique_constraint(:name, name: :characters_game_id_name_index)
  end

  def approve_changeset(struct) do
    struct
    |> change()
    |> put_change(:state, "approved")
  end

  def deny_changeset(struct) do
    struct
    |> change()
    |> put_change(:state, "denied")
  end
end
