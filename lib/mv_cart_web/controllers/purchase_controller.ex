defmodule MvCartWeb.PurchaseController do
  use MvCartWeb, :controller

  alias MvCart.Sales
  alias MvCart.Catalog
  alias MvCart.Sales.Purchase
  alias MvCart.Guardian
  alias Decimal

  action_fallback MvCartWeb.FallbackController

  def create(conn, %{"purchase" => purchase_params}) do
    user = Guardian.Plug.current_resource(conn)
    purchase_params = Map.put(purchase_params, "user_id", user.id)

    with {:ok, product} <- Catalog.get_product(purchase_params["product_id"]),
         :ok <- validate_quantity(product, purchase_params["quantity"]),
         total_cost <- Decimal.mult(product.price, Decimal.new(purchase_params["quantity"])),
         :ok <- validate_ledger_balance(user.id, total_cost),
         {:ok, %Purchase{} = purchase} <- Sales.create_purchase(purchase_params),
         {:ok, _product} <- Catalog.update_product_quantity(product, purchase_params["quantity"]),
         {:ok, _transaction} <-
           Sales.create_wallet_transaction(%{
             wallet_id: user.wallet.id,
             amount: Decimal.negate(total_cost),
             purchase_id: purchase.id
           }) do
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

  defp validate_ledger_balance(user_id, total_cost) do
    case Sales.calculate_balance(user_id) do
      {:ok, balance} ->
        if Decimal.compare(balance, total_cost) != :lt do
          :ok
        else
          {:error, "Insufficient balance"}
        end

      {:error, _reason} ->
        {:error, "Error calculating balance"}
    end
  end

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    purchases = Sales.list_user_purchases(user.id)
    render(conn, :index, purchases: purchases)
  end
end
