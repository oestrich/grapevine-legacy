defmodule Grapevine.Channels do
  @moduledoc """
  Sync Gossip channels
  """

  alias Grapevine.Channels.Channel
  alias Grapevine.Repo

  @doc """
  Get all channels
  """
  @spec all() :: [Channel.t()]
  def all() do
    Repo.all(Channel)
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
