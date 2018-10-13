defmodule Grapevine.Tells do
  @moduledoc """
  Tells helper for Gossip
  """

  use GenServer

  alias Grapevine.Tells.Server

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def tell_received(from_game, from_player, to_player, message) do
    GenServer.cast(__MODULE__, {:tell, from_game, from_player, to_player, message})
  end

  def init(_) do
    {:ok, %{}}
  end

  @doc """
  A new tell is received
  """
  def handle_cast({:tell, from_game, from_player, "system", message}, state) do
    Server.system_tell(from_game, from_player, message)
    {:noreply, state}
  end

  def handle_cast({:tell, _from_game, _from_player, _to_player, _message}, state) do
    {:noreply, state}
  end
end
