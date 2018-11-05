defmodule Metrics.Setup do
  @moduledoc """
  Common area to set up metrics
  """

  def setup() do
    Metrics.PlugExporter.setup()
  end
end
