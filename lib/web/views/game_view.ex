defmodule Web.GameView do
  use Web, :view

  alias Grapevine.Games

  def game_online?(game), do: Games.game_online?(game)

  def online_players(game) do
    Map.get(Gossip.who(), game.short_name, [])
  end

  def online_status(game) do
    active_cutoff = Timex.now() |> Timex.shift(minutes: -1)

    case Timex.before?(active_cutoff, game.last_seen_at) do
      true ->
        content_tag(:i, "", class: "fa fa-circle online", alt: "Game Online", title: "Online")

      _ ->
        mssp_cutoff = Timex.now() |> Timex.shift(minutes: -90)

        case Timex.before?(mssp_cutoff, game.mssp_last_seen_at) do
          true ->
            content_tag(:i, "", class: "fa fa-adjust online", alt: "Seen on MSSP", title: "Seen on MSSP")

          _ ->
            content_tag(:i, "", class: "fa fa-circle offline", alt: "Game Offline", title: "Offline")
        end
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

  def game_statistic_path(short_name) do
    Grapevine.gossip_base_url() <> "/games/#{short_name}/stats/players"
  end
end
