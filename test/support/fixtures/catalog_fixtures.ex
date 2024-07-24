defmodule MvCart.CatalogFixtures do
  alias MvCart.Catalog

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: "120.5",
        quantity: 42,
        image: "some_image.jpg"
      })
      |> Catalog.create_product()

    product
  end
end
