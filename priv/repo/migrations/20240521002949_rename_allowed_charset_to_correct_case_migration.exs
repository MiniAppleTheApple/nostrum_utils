defmodule Mark.Repo.Migrations.RenameAllowedCharsetToCorrectCaseMigration do
  use Ecto.Migration

  def change do
    alter table("server") do
      remove :allowedCharsetMigration
      add :allowed_charset, :integer, default: 0
    end
  end
end
