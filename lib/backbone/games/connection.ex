defmodule Backbone.Games.Connection do
  @moduledoc """
  Embedded schema for a connection
  """

  use Backbone.Schema

  embedded_schema do
    field(:type, :string)
    field(:url, :string)
    field(:host, :string)
    field(:port, :integer)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:type, :url, :host, :port])
    |> validate_required([:type])
  end
end
