import Config

config :mark, ecto_repos: [Mark.Repo]

config :mark, Mark.Repo,
  username: "postgres",
  password: "pwd",
  database: "postgres",
  hostname: "localhost"
