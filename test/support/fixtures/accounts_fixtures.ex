defmodule MvCart.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvCart.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password_hash: "some password_hash"
      })
      |> MvCart.Accounts.create_user()

    user
  end

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(attrs \\ %{}) do
    {:ok, wallet} =
      attrs
      |> Enum.into(%{
        user_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> MvCart.Accounts.create_wallet()

    wallet
  end
end
