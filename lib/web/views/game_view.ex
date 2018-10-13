defmodule Web.GameView do
  use Web, :view

  def connection_info(connection) do
    case connection.type do
      "web" ->
        link(connection.url, to: connection.url, target: "_blank")

      "telnet" ->
        "#{connection.host}:#{connection.port}"

      "secure telnet" ->
        "#{connection.host}:#{connection.port}"
    end
  end
end
