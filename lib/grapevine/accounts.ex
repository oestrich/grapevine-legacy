defmodule Grapevine.Accounts do
  @moduledoc """
  Context for accounts
  """

  require Logger

  import Ecto.Query

  alias Grapevine.Accounts.User
  alias Grapevine.Emails
  alias Grapevine.Mailer
  alias Grapevine.Repo

  @type id :: integer()
  @type username :: String.t()
  @type user_params :: map()
  @type token :: String.t()
  @type registration_key :: UUID.t()

  @doc """
  Start a new user
  """
  @spec new() :: Ecto.Changeset.t()
  def new(), do: %User{} |> User.changeset(%{})

  @doc """
  Profile id for a user

  www-form encoded username
  """
  def profile_id(user) do
    URI.encode_www_form(user.username)
  end

  @doc """
  Register a new user
  """
  @spec register(user_params()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def register(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Find a user by the token
  """
  @spec from_token(token()) :: {:ok, User.t()} | {:error, :not_found}
  def from_token(token) do
    case Repo.get_by(User, token: token) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Get a user by id
  """
  @spec get(id()) :: {:ok, User.t()} | {:error, :not_found}
  def get(id) do
    case Repo.get_by(User, id: id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Get a user by name
  """
  @spec get_by_username(username()) :: {:ok, User.t()} | {:error, :not_found}
  def get_by_username(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, preload(user)}
    end
  end

  @doc """
  Get a user by their registration key
  """
  @spec get_by_registration_key(registration_key()) :: {:ok, User.t()} | {:error, :not_found}
  def get_by_registration_key(key) do
    with {:ok, key} <- Ecto.UUID.cast(key) do
      case Repo.get_by(User, registration_key: key) do
        nil ->
          {:error, :not_found}

        user ->
          {:ok, user}
      end
    else
      _ ->
        {:error, :not_found}
    end
  end

  defp preload(user) do
    Repo.preload(user, [characters: [:game]])
  end

  def regenerate_registration_key(user) do
    user
    |> User.regen_key_changeset()
    |> Repo.update()
  end

  @doc """
  Validate a login
  """
  @spec validate_login(String.t(), String.t()) :: {:ok, User.t()} | {:error, :invalid}
  def validate_login(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :invalid}

      user ->
        check_password(user, password)
    end
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true ->
        {:ok, user}

      false ->
        {:error, :invalid}
    end
  end

    @doc """
  Start password reset
  """
  @spec start_password_reset(String.t()) :: :ok
  def start_password_reset(email) do
    query = User |> where([u], u.email == ^email)

    case query |> Repo.one() do
      nil ->
        Logger.warn("Password reset attempted for #{email}")

        :ok

      user ->
        Logger.info("Starting password reset for #{user.email}")

        user
        |> User.password_reset_changeset()
        |> Repo.update!()
        |> Emails.password_reset()
        |> Mailer.deliver_now()

        :ok
    end
  end

  @doc """
  Reset a password
  """
  @spec reset_password(String.t(), map()) :: {:ok, User.t()} | :error
  def reset_password(token, params) do
    with {:ok, uuid} <- Ecto.UUID.cast(token),
         {:ok, user} <- find_user_by_reset_token(uuid),
         {:ok, user} <- check_password_reset_expired(user) do
      user
      |> User.password_changeset(params)
      |> Repo.update()
    end
  end

  defp find_user_by_reset_token(uuid) do
    query = User |> where([u], u.password_reset_token == ^uuid)

    case query |> Repo.one() do
      nil ->
        :error

      user ->
        {:ok, user}
    end
  end

  defp check_password_reset_expired(user) do
    case Timex.after?(Timex.now(), user.password_reset_expires_at) do
      true ->
        :error

      false ->
        {:ok, user}
    end
  end

  @doc """
  Load the list of blocked usernames

  File is in `priv/users/block-list.txt`

  This file is a newline separated list of downcased names
  """
  @spec username_blocklist() :: [username()]
  def username_blocklist() do
    blocklist = Path.join(:code.priv_dir(:grapevine), "users/block-list.txt")
    {:ok, blocklist} = File.read(blocklist)

    blocklist
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
  end
end
