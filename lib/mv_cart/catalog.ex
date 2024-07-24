defmodule MvCart.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias MvCart.Repo

  alias MvCart.Catalog.Product

  def create_product(params) do
    %Product{}
    |> Product.changeset(params)
    |> Repo.insert()
  end

  def list_products do
    Repo.all(Product)
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def get_product(id) do
    case Repo.get(Product, id) do
      nil -> {:error, :not_found}
      product -> {:ok, product}
    end
  end

  def update_product_quantity(%Product{} = product, quantity) do
    updated_quantity = product.quantity - quantity

    product
    |> Product.changeset(%{quantity: updated_quantity})
    |> Repo.update()
  end
end
