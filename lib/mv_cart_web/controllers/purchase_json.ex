defmodule MvCartWeb.PurchaseJSON do
  alias MvCart.Sales.Purchase

  @doc """
  Renders a list of purchases.
  """
  def index(%{purchases: purchases}) do
    %{data: for(purchase <- purchases, do: data(purchase))}
  end

  @doc """
  Renders a single purchase.
  """
  def show(%{purchase: purchase}) do
    %{data: data(purchase)}
  end

  defp data(%Purchase{} = purchase) do
    %{
      id: purchase.id,
      quantity: purchase.quantity,
      user_id: purchase.user_id,
      product_id: purchase.product_id
    }
  end
end
