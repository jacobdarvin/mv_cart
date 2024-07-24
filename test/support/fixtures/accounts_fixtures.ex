defmodule MvCart.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvCart.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some_email_#{System.unique_integer([:positive])}@gmail.com"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email()
      })
      |> MvCart.Accounts.create_user_with_wallet()

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
