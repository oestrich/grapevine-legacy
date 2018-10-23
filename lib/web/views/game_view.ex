defmodule Web.GameView do
  use Web, :view

  alias Grapevine.Games

  def online_status(game) do
    case Games.game_online?(game) do
      true ->
        content_tag(:i, "", class: "fa fa-circle online")

      false ->
        content_tag(:i, "", class: "fa fa-circle offline")
    end
  end

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
