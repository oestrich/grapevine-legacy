defmodule Grapevine.GamesTest do
  use Grapevine.DataCase

  alias Grapevine.Games

  describe "sync remote games" do
    test "creates local copies" do
      :ok = Games.cache_remote([
        %{"id" => 1, "game" => "gossip", "display_name" => "Gossip", "display" => true}
      ])

      assert length(Games.all()) == 1
    end

    test "creates local copies, handles updates" do
      :ok = Games.cache_remote([
        %{"id" => 1, "game" => "gossip", "display_name" => "Gossip", "display" => true}
      ])

      :ok = Games.cache_remote([
        %{"id" => 1, "game" => "gossip", "display_name" => "Updated", "display" => true}
      ])

      assert length(Games.all()) == 1

      {:ok, game} = Games.get("Updated")
      assert game.short_name == "gossip"
    end

    test "copies connections over" do
      :ok = Games.cache_remote([
        %{
          "id" => 1,
          "game" => "gossip",
          "display_name" => "Gossip",
          "display" => true,
          "connections" => [
            %{"type" => "web", "url" => "https://example.com/play"},
            %{"type" => "telnet", "host" => "example.com", "port" => 4000},
            %{"type" => "secure telnet", "host" => "example.com", "port" => 4000},
          ]
        }
      ])

      {:ok, game} = Games.get("Gossip")
      assert length(game.connections) == 3
    end

    test "updates connections" do
      game = %{
          "id" => 1,
          "game" => "gossip",
          "display_name" => "Gossip",
          "display" => true,
          "connections" => [
            %{"type" => "web", "url" => "https://example.com/play"},
            %{"type" => "telnet", "host" => "example.com", "port" => 4000},
            %{"type" => "secure telnet", "host" => "example.com", "port" => 4000},
          ]
        }

      :ok = Games.cache_remote([game])
      :ok = Games.cache_remote([game])

      {:ok, game} = Games.get("Gossip")
      assert length(game.connections) == 3
    end
  end
end
