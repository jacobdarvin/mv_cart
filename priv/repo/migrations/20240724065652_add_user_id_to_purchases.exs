defmodule MvCart.Repo.Migrations.AddUserIdToPurchases do
  use Ecto.Migration

  def change do
    alter table(:purchases) do
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
    end

    create index(:purchases, [:user_id])
  end
end
