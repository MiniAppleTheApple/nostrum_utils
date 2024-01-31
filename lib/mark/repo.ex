defmodule Mark.Repo do
  use Ecto.Repo,
    otp_app: :mark,
    adapter: Ecto.Adapters.Postgres
end
