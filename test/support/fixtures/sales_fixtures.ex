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
end
