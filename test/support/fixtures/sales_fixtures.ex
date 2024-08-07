defmodule MvCart.SalesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MvCart.Sales` context.
  """

  alias MvCart.CatalogFixtures
  alias MvCart.AccountsFixtures

  @doc """
  Generate a purchase.
  """
  def purchase_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()
    product = CatalogFixtures.product_fixture()

    {:ok, purchase} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        product_id: product.id,
        quantity: 42
      })
      |> MvCart.Sales.create_purchase()

    purchase
  end

  @doc """
  Generate a wallet_transaction.
  """
  def wallet_transaction_fixture(attrs \\ %{}) do
    # Ensure a valid purchase is created
    purchase = purchase_fixture()

    {:ok, wallet_transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        purchase_id: purchase.id,
        wallet_id: Ecto.UUID.generate()
      })
      |> MvCart.Sales.create_wallet_transaction()

    wallet_transaction
  end
end
