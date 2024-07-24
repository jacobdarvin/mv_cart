defmodule MvCartWeb.ProductController do
  use MvCartWeb, :controller

  alias MvCart.Catalog

  action_fallback MvCartWeb.FallbackController

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, :index, products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, :show, product: product)
  end
end
