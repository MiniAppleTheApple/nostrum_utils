defmodule Mark.Repo.Migrations.AddAllowedCharsetMigration do
  use Ecto.Migration

  def change do
    alter table("server") do
      add :allowedCharsetMigration, :integer, default: ""
    end
    flush()
  end
end
