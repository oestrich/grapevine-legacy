defmodule Backbone.Channels.Channel do
  @moduledoc """
  Schema for channels
  """

  use Backbone.Schema

  schema "channels" do
    field(:remote_id, :integer)
    field(:name, :string)
    field(:description, :string)
    field(:hidden, :boolean)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:remote_id, :name, :description, :hidden])
    |> validate_required([:remote_id, :name, :hidden])
  end
end
