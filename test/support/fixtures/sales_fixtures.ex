defmodule MvCart.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvCart.Sales` context.
  """

  @doc """
  Generate a purchase.
  """
  def purchase_fixture(attrs \\ %{}) do
    {:ok, purchase} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> MvCart.Sales.create_purchase()

    purchase
  end

  @doc """
  Generate a wallet_transaction.
  """
  def wallet_transaction_fixture(attrs \\ %{}) do
    {:ok, wallet_transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        purchase_id: "7488a646-e31f-11e4-aace-600308960662",
        wallet_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> MvCart.Sales.create_wallet_transaction()

    wallet_transaction
  end
end
