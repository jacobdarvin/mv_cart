defmodule MvCart.Sales.WalletTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallet_transactions" do
    field :purchase_id, Ecto.UUID
    field :wallet_id, Ecto.UUID
    field :amount, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet_transaction, attrs) do
    wallet_transaction
    |> cast(attrs, [:purchase_id, :wallet_id, :amount])
    |> validate_required([:purchase_id, :wallet_id, :amount])
  end
end
