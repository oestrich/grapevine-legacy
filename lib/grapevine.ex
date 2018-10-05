defmodule Grapevine do
  @moduledoc """
  Grapevine main module
  """

  @doc """
  Get the running version of Grapevine
  """
  def version() do
    grapevine =
      :application.loaded_applications()
      |> Enum.find(&(elem(&1, 0) == :grapevine))

    "Grapevine v#{elem(grapevine, 2)}"
  end
end
