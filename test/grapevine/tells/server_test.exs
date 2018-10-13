defmodule Grapevine.Tells.ServerTest do
  use Grapevine.DataCase

  alias Grapevine.Tells.Server
  alias Test.Gossip

  describe "receiving tells" do
    test "unknown operation" do
      :ok = Server.system_tell("ExVenture", "player", "hello")

      message = "Hello! This is Grapvine. Please checkout https://grapevine.haus/ for information on how to register a character."
      assert [{"system", "ExVenture", "player", ^message}] = Gossip.get_tells() 
    end
  end

  describe "receiving a new tell to register a character" do
    test "receives a valid user code" do
      cache_game(%{"game" => "ExVenture"})

      user = create_user()
      
      :ok = Server.system_tell("ExVenture", "player", "register #{user.registration_key}")

      message = "User registration initiated. Check your profile to complete registration!"
      assert [{"system", "ExVenture", "player", ^message}] = Gossip.get_tells() 
    end

    test "receives an invalid user code" do
      cache_game(%{"game" => "ExVenture"})
      
      :ok = Server.system_tell("ExVenture", "player", "register hi")

      assert Gossip.get_tells() == [{"system", "ExVenture", "player", "Unknown registration key."}]
    end

    test "unknown game" do
      :ok = Server.system_tell("unknown", "to", "register hi")

      assert [{_, _, _, "An unknown" <> _}] = Gossip.get_tells()
    end
  end
end
