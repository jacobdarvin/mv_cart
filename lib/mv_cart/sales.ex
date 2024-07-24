defmodule MvCart.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias MvCart.Repo

  alias MvCart.Sales.Purchase
  alias MvCart.Sales.WalletTransaction
  alias MvCart.Accounts.Wallet

  def list_user_purchases(user_id) do
    Repo.all(from p in Purchase, where: p.user_id == ^user_id)
  end

  def create_purchase(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  def top_up_wallet(user_id, amount) when amount > 0 do
    Repo.transaction(fn ->
      wallet = Repo.get_by!(Wallet, user_id: user_id)
      IO.inspect(wallet, label: "Wallet")

      %WalletTransaction{}
      |> WalletTransaction.changeset(%{wallet_id: wallet.id, amount: amount})
      |> Repo.insert()
    end)
  end

  def calculate_balance(user_id) do
    wallet = Repo.get_by(Wallet, user_id: user_id)

    case wallet do
      nil ->
        {:error, :not_found}

      _ ->
        balance =
          Repo.aggregate(
            from(t in WalletTransaction, where: t.wallet_id == ^wallet.id),
            :sum,
            :amount
          ) || Decimal.new("0.00")

        {:ok, balance}
    end
  end

  def create_wallet_transaction(attrs \\ %{}) do
    %WalletTransaction{}
    |> WalletTransaction.changeset(attrs)
    |> Repo.insert()
  end
end
