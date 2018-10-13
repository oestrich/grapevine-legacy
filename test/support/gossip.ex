defmodule Test.Gossip do
  @moduledoc """
  Test mock for Gossip
  """

  use Agent

  def start_link(_) do
    Agent.start_link(fn () -> %{} end, name: __MODULE__)
  end

  def send_tell(from_user, to_game, to_player, message) do
    Agent.update(__MODULE__, fn state ->
      tells = Map.get(state, :tells, [])
      Map.put(state, :tells, [{from_user, to_game, to_player, message} | tells])
    end)

    :ok
  end

  def get_tells() do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, :tells, [])
    end)
  end
end
