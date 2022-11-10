defmodule NekoPreto.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :user_id, :string
      add :hp, :integer, default: 10
      add :atk, :integer, default: 0
    end
  end
end
