defmodule MvCart.CatalogTest do
  use MvCart.DataCase

  alias MvCart.Catalog
  alias MvCart.Catalog.Product

  import MvCart.CatalogFixtures

  describe "create_product/1" do
    test "returns product" do
      params = %{
        name: "Name",
        description: "Description",
        quantity: 5,
        price: 120.00,
        image: "randomlink.jpg"
      }

      name = params.name
      assert {:ok, %Product{name: ^name}} = Catalog.create_product(params)
    end
  end
end
