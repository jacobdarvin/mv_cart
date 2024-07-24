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

    test "returns error if product params are invalid (image is blank)" do
      params = %{
        name: "Name",
        description: "Description",
        quantity: 5,
        price: 120.00
      }

      assert {:error, changeset} = Catalog.create_product(params)
      assert changeset.valid? == false
      assert [image: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end

  describe "list_products/0" do
    test "returns list of products" do
      _product1 = product_fixture(%{name: "Product 1"})
      _product2 = product_fixture(%{name: "Product 2"})

      products = Catalog.list_products()

      assert length(products) == 2
      assert Enum.any?(products, fn product -> product.name == "Product 1" end)
      assert Enum.any?(products, fn product -> product.name == "Product 2" end)
    end

    test "returns empty list if no product found" do
      Repo.delete_all(Product)

      products = Catalog.list_products()

      assert products == []
    end
  end
end
