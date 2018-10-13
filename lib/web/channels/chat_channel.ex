defmodule Web.ChatChannel do
  @moduledoc """
  User Channel for admins
  """

  use Phoenix.Channel

  alias Backbone.Channels

  def join("chat:" <> channel, _message, socket) do
    case Map.has_key?(socket.assigns, :user) do
      true ->
        socket
        |> assign_channel(channel)

      false ->
        {:error, %{reason: "user required"}}
    end
  end

  defp assign_channel(socket, channel) do
    case Channels.get(channel) do
      {:ok, channel} ->
        socket = assign(socket, :channel, channel)

        {:ok, socket}

      {:error, :not_found} ->
        {:error, %{reason: "no such channel"}}
    end
  end

  def handle_in("send", %{"message" => message}, socket) do
    %{channel: channel, user: user} = socket.assigns

    message = %{
      channel: channel.name,
      name: user.username,
      message: message,
    }

    Web.Endpoint.broadcast("chat:#{message.channel}", "broadcast", message)
    Gossip.broadcast(message.channel, message)

    {:noreply, socket}
  end
end
