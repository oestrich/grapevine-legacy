defmodule Grapevine.Tells.Server do
  @moduledoc """
  Implementation details for the Tells GenServer
  """

  alias Grapevine.Accounts
  alias Grapevine.Characters
  alias Grapevine.Games

  @gossip Application.get_env(:grapevine, :gossip)[:module]

  def system_tell(from_game, from_player, message) do
    case String.downcase(String.trim(message)) do
      "register" <> _ ->
        register_character(from_game, from_player, message)

      _ ->
        message = "Hello! This is Grapvine. Please checkout https://grapevine.haus/ for information on how to register a character."
        @gossip.send_tell("system", from_game, from_player, message)
    end
  end

  defp register_character(from_game, from_player, message) do
    key = String.trim(String.replace(message, "register", ""))

    with {:ok, game} <- Games.get_by_name(from_game),
         {:ok, game} <- check_allowed_to_register(game),
         {:ok, user} <- get_user_by_key(key),
         {:ok, _character} <- start_registration(user, game, from_player) do
      message = "User registration initiated. Check your profile to complete registration!"
      @gossip.send_tell("system", game.short_name, from_player, message)
    else
      {:error, :cannot_register} ->
        message = "Your game does not allow registering characters on Grapevine. Sorry :("
        @gossip.send_tell("system", from_game, from_player, message)

      {:error, :unknown_key} ->
        @gossip.send_tell("system", from_game, from_player, "Unknown registration key.")

      {:error, :already_registered} ->
        @gossip.send_tell("system", from_game, from_player, "This character is already registered.")
        @gossip.send_tell("system", from_game, from_player, "Please check your Grapevine profile.")

      _ ->
        @gossip.send_tell("system", from_game, from_player, "An unknown error occurred. Please try again")
    end
  end

  defp check_allowed_to_register(game) do
    case game.allow_character_registration do
      true ->
        {:ok, game}

      false ->
        {:error, :cannot_register}
    end
  end

  defp get_user_by_key(key) do
    case Accounts.get_by_registration_key(key) do
      {:ok, user} ->
        {:ok, user}

      {:error, :not_found} ->
        {:error, :unknown_key}
    end
  end

  defp start_registration(user, game, from_player) do
    case Characters.start_registration(user, game, from_player) do
      {:ok, character} ->
        {:ok, character}

      {:error, _changeset} ->
        {:error, :already_registered}
    end
  end
end
