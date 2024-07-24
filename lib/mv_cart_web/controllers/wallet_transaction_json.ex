defmodule MvCartWeb.WalletTransactionJSON do
  alias MvCart.Sales.WalletTransaction

  @doc """
  Renders a list of wallet_transactions.
  """
  def index(%{wallet_transactions: wallet_transactions}) do
    %{data: for(wallet_transaction <- wallet_transactions, do: data(wallet_transaction))}
  end

  @doc """
  Renders a single wallet_transaction.
  """
  def show(%{wallet_transaction: wallet_transaction}) do
    %{data: data(wallet_transaction)}
  end

  defp data(%WalletTransaction{} = wallet_transaction) do
    %{
      id: wallet_transaction.id,
      purchase_id: wallet_transaction.purchase_id,
      wallet_id: wallet_transaction.wallet_id,
      amount: wallet_transaction.amount
    }
  end
end
