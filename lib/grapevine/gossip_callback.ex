defmodule Grapevine.GossipCallback do
  @behaviour Gossip.Client

  @impl true
  def user_agent(), do: Grapevine.version()

  @impl true
  def channels(), do: []

  @impl true
  def players(), do: ["system"]

  @impl true
  def message_broadcast(_message), do: :ok

  @impl true
  def player_sign_in(_game_name, _player_name), do: :ok

  @impl true
  def player_sign_out(_game_name, _player_name), do: :ok

  @impl true
  def players_status(_game_name, _player_names), do: :ok

  @impl true
  def tell_received(_from_game, _from_player, _to_player, _message), do: :ok
end
