defmodule MvCart.Accounts.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "wallets" do
    belongs_to :user, MvCart.Accounts.User, type: :binary_id
    has_many :wallet_transactions, MvCart.Sales.WalletTransaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
