defmodule MvCart.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :description, :string
    field :quantity, :integer
    field :price, :decimal
    field :image, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :quantity, :price, :image])
    |> validate_required([:name, :description, :quantity, :price, :image])
  end
end
