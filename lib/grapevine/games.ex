defmodule Grapevine.Games do
  @moduledoc """
  Context for caching remote games from Gossip
  """

  alias Grapevine.Games.Game
  alias Grapevine.RemoteSchema
  alias Grapevine.Repo

  @doc """
  Get all games
  """
  @spec all() :: [Game.t()]
  def all(), do: Repo.all(Game)

  @doc """
  Get a game by name
  """
  def get(name) do
    case Repo.get_by(Game, name: name) do
      nil ->
        {:error, :not_found}

      game ->
        {:ok, game}
    end
  end

  @doc """
  Cache remote games

  Create or update remote games
  """
  def cache_remote(games) do
    Enum.each(games, &cache_game/1)

    :ok
  end

  defp cache_game(attributes) do
    remote_id = Map.get(attributes, "id")

    attributes = RemoteSchema.map_fields(attributes, %{
      "id" => "remote_id",
      "game" => "short_name",
      "display_name" => "name",
    })

    case Repo.get_by(Game, remote_id: remote_id) do
      nil ->
        %Game{}
        |> Game.changeset(attributes)
        |> Repo.insert()

      game ->
        game
        |> Game.changeset(attributes)
        |> Repo.update()
    end
  end
end
