defmodule MvCart.Sales.WalletTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallet_transactions" do
    belongs_to :purchase, MvCart.Sales.Purchase, type: :binary_id
    belongs_to :wallet, MvCart.Accounts.Wallet, type: :binary_id
    field :amount, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet_transaction, attrs) do
    wallet_transaction
    |> cast(attrs, [:purchase_id, :wallet_id, :amount])
    |> validate_required([:wallet_id, :amount])
  end
end
