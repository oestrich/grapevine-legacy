defmodule Grapevine.Games do
  @moduledoc """
  Context for caching remote games from Gossip
  """

  @type opts :: Keyword.t()

  alias Grapevine.Games.Game
  alias Grapevine.RemoteSchema
  alias Grapevine.Repo

  import Ecto.Query

  @doc """
  Get all games
  """
  @spec all(opts()) :: [Game.t()]
  def all(opts \\ []) do
    Game
    |> order_by([g], g.id)
    |> maybe_include_hidden(opts)
    |> Repo.all()
  end

  defp maybe_include_hidden(query, opts) do
    case Keyword.get(opts, :include_hidden, false) do
      false ->
        query |> where([g], g.display == true)

      true ->
        query
    end
  end

  @doc """
  Get a game by name
  """
  def get(id, opts \\ []) do
    case Repo.get_by(Game, Keyword.merge(opts, [id: id])) do
      nil ->
        {:error, :not_found}

      game ->
        {:ok, game}
    end
  end

  @doc """
  Get a game by name
  """
  def get_by_name(name) do
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
