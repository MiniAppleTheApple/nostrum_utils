defmodule Mark.Schema.Role do
  use Ecto.Schema

  schema "role" do
    belongs_to(:server, Mark.Schema.Server)
  end
end
