defmodule Mark.Schema.Server do
  alias Mark.AllowedCharset

  use Ecto.Schema

  schema "server" do
    has_many :needed_roles, Mark.Schema.Role
    field :ref, :string
    field :name, :string
    field :allowed_charset, :integer
  end

  def new(guild_id, name) do
    %__MODULE__{ref: guild_id |> to_string(), name: name, allowed_charset: AllowedCharset.default()}
  end
end
