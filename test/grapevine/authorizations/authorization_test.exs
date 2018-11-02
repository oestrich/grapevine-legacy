defmodule Grapevine.Authorizations.AuthorizationTest do
  use ExUnit.Case

  alias Backbone.Games.Game
  alias Grapevine.Authorizations.Authorization

  describe "validations" do
    test "redirect_uri must be https" do
      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/"})
      refute changeset.errors[:redirect_uri]

      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "http://example.com/"})
      assert changeset.errors[:redirect_uri]
    end

    test "redirect_uri must be a full uri" do
      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/"})
      refute changeset.errors[:redirect_uri]

      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://"})
      assert changeset.errors[:redirect_uri]
    end

    test "redirect_uri must include a path" do
      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/"})
      refute changeset.errors[:redirect_uri]

      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com"})
      assert changeset.errors[:redirect_uri]
    end

    test "redirect_uri must not include a query" do
      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/"})
      refute changeset.errors[:redirect_uri]

      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/?query"})
      assert changeset.errors[:redirect_uri]
    end

    test "redirect_uri must not include a fragment" do
      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/"})
      refute changeset.errors[:redirect_uri]

      changeset = %Authorization{} |> Authorization.create_changeset(%Game{}, %{redirect_uri: "https://example.com/#fragment"})
      assert changeset.errors[:redirect_uri]
    end
  end
end
