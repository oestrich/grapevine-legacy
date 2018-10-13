defmodule Backbone.RemoteSchema do
  @moduledoc """
  Functions for dealing with remote schemas from Gossip
  """

  @doc """
  Map incoming keys to local fields
  """
  def map_fields(attributes, fields) do
    Enum.reduce(fields, attributes, fn {from, to}, attributes ->
      value = Map.get(attributes, from)

      attributes
      |> Map.put(to, value)
      |> Map.delete(from)
    end)
  end
end
