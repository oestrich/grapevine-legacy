defmodule Grapevine.Games.Game do
  @moduledoc """
  Schema for remote games
  """

  use Grapevine.Schema

  alias Grapevine.Games.Connection

  schema "games" do
    field(:remote_id, :integer)
    field(:name, :string)
    field(:short_name, :string)
    field(:user_agent, :string)
    field(:user_agent_repo_url, :string)
    field(:description, :string)
    field(:homepage_url, :string)

    embeds_many(:connections, Connection, on_replace: :delete)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:remote_id, :name, :short_name, :user_agent, :user_agent_repo_url, :description, :homepage_url])
    |> cast_embed(:connections, with: &Connection.changeset/2)
    |> validate_required([:remote_id, :name, :short_name, :connections])
  end
end