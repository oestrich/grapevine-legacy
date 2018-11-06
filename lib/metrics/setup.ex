defmodule Metrics.Setup do
  @moduledoc """
  Common area to set up metrics
  """

  def setup() do
    Metrics.OAuthInstrumenter.setup()

    Metrics.PlugExporter.setup()
  end
end
