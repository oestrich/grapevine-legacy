defmodule Grapevine.Accounts.User do
  @moduledoc """
  User schema
  """

  use Grapevine.Schema

  alias Grapevine.Accounts
  alias Grapevine.Authorizations.Authorization
  alias Grapevine.Characters.Character

  schema "users" do
    field(:uid, Ecto.UUID, read_after_writes: true)
    field(:username, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)
    field(:token, Ecto.UUID)
    field(:registration_key, Ecto.UUID, read_after_writes: true)

    has_many(:authorizations, Authorization)
    has_many(:characters, Character)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:username, :email, :password, :password_confirmation])
    |> trim(:username)
    |> trim(:email)
    |> check_username_against_block_list()
    |> validate_required([:username, :email])
    |> validate_format(:username, ~r/^[a-zA-Z0-9-]+$/)
    |> validate_length(:username, min: 3, max: 50)
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> ensure(:token, UUID.uuid4())
    |> hash_password()
    |> validate_required([:password_hash])
    |> validate_confirmation(:password)
    |> unique_constraint(:username, name: :users_lower_username_index)
    |> unique_constraint(:email, name: :users_lower_email_index)
  end

  def regen_key_changeset(struct) do
    struct
    |> change()
    |> put_change(:registration_key, UUID.uuid4())
  end

  defp trim(changeset, field) do
    case get_change(changeset, field) do
      nil ->
        changeset

      value ->
        put_change(changeset, field, String.trim(value))
    end
  end

  defp check_username_against_block_list(changeset) do
    case get_change(changeset, :username) do
      nil ->
        changeset

      username ->
        case Enum.member?(Accounts.username_blocklist(), String.downcase(username)) do
          true ->
            add_error(changeset, :username, "is blocked")

          false ->
            changeset
        end
    end
  end

  defp hash_password(changeset) do
    case changeset do
      %{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
