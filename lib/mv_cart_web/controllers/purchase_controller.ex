defmodule MvCartWeb.PurchaseController do
  use MvCartWeb, :controller

  alias MvCart.Sales
  alias MvCart.Catalog
  alias MvCart.Sales.Purchase

  action_fallback MvCartWeb.FallbackController

  def create(conn, %{"purchase" => purchase_params}) do
    with {:ok, product} <- Catalog.get_product(purchase_params["product_id"]),
         :ok <- validate_quantity(product, purchase_params["quantity"]),
         {:ok, %Purchase{} = purchase} <- Sales.create_purchase(purchase_params),
         {:ok, _product} <- Catalog.update_product_quantity(product, purchase_params["quantity"]) do
      conn
      |> put_status(:created)
      |> json(%{
        id: purchase.id,
        product_id: purchase.product_id,
        quantity: purchase.quantity,
        inserted_at: purchase.inserted_at
      })
    else
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  defp validate_quantity(%Catalog.Product{quantity: available_quantity}, purchase_quantity) do
    if purchase_quantity > 0 and purchase_quantity <= available_quantity do
      :ok
    else
      {:error, "Invalid quantity"}
    end
  end
end
