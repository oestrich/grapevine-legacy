defmodule Grapevine.Channels do
  @moduledoc """
  Sync Gossip channels
  """

  import Ecto.Query

  alias Grapevine.Channels.Channel
  alias Grapevine.Repo

  @type opts :: Keyword.t()

  @doc """
  Get all channels
  """
  @spec all(opts()) :: [Channel.t()]
  def all(opts \\ []) do
    Channel
    |> maybe_include_hidden(opts)
    |> Repo.all()
  end

  defp maybe_include_hidden(query, opts) do
    case Keyword.get(opts, :include_hidden, false) do
      true ->
        query

      false ->
        query |> where([c], c.hidden == false)
    end
  end

  @doc """
  Get a channel by name
  """
  def get(name) do
    case Repo.get_by(Channel, name: name) do
      nil ->
        {:error, :not_found}

      channel ->
        {:ok, channel}
    end
  end

  @doc """
  Cache remote channels

  Create or update remote channels
  """
  def cache_remote(channels) do
    Enum.each(channels, &cache_channel/1)

    :ok
  end

  defp cache_channel(attributes) do
    remote_id = Map.get(attributes, "id")

    attributes =
      attributes
      |> Map.put("remote_id", remote_id)
      |> Map.delete("id")

    case Repo.get_by(Channel, remote_id: remote_id) do
      nil ->
        %Channel{}
        |> Channel.changeset(attributes)
        |> Repo.insert()

      channel ->
        channel
        |> Channel.changeset(attributes)
        |> Repo.update()
    end
  end
end
