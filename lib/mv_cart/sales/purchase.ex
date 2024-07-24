defmodule MvCart.Sales.Purchase do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "purchases" do
    field :quantity, :integer
    belongs_to :user, MvCart.Accounts.User, type: :binary_id
    belongs_to :product, MvCart.Catalog.Product, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [:quantity, :user_id, :product_id])
    |> validate_required([:quantity, :user_id, :product_id])
  end
end
