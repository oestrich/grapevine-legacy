defmodule Grapevine.ChannelsTest do
  use Grapevine.DataCase

  alias Grapevine.Channels

  describe "sync remote channels" do
    test "creates local copies" do
      :ok = Channels.cache_remote([
        %{"id" => 1, "name" => "gossip", "description" => nil, "hidden" => true}
      ])

      assert length(Channels.all()) == 1
    end

    test "creates local copies, handles updates" do
      :ok = Channels.cache_remote([
        %{"id" => 1, "name" => "gossip", "description" => nil, "hidden" => true}
      ])

      :ok = Channels.cache_remote([
        %{"id" => 1, "name" => "gossip", "description" => "updated", "hidden" => true}
      ])

      assert length(Channels.all()) == 1

      {:ok, channel} = Channels.get("gossip")
      assert channel.description == "updated"
    end
  end
end
