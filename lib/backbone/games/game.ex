defmodule Backbone.Games.Game do
  @moduledoc """
  Schema for remote games
  """

  use Backbone.Schema

  alias Backbone.Games.Connection

  schema "games" do
    field(:remote_id, :integer)
    field(:name, :string)
    field(:short_name, :string)
    field(:display, :boolean)
    field(:user_agent, :string)
    field(:user_agent_url, :string)
    field(:description, :string)
    field(:homepage_url, :string)
    field(:allow_character_registration, :boolean)

    embeds_many(:connections, Connection, on_replace: :delete)

    timestamps()
  end

  @fields [
    :remote_id,
    :name,
    :short_name,
    :display,
    :user_agent,
    :user_agent_url,
    :description,
    :homepage_url,
    :allow_character_registration
  ]

  def changeset(struct, params) do
    struct
    |> cast(params, @fields)
    |> cast_embed(:connections, with: &Connection.changeset/2)
    |> validate_required([:remote_id, :name, :short_name, :display, :connections])
    |> unique_constraint(:short_name, name: :games_lower_short_name_index)
  end
end
