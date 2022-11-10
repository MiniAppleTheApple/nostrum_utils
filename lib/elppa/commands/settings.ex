defmodule Elppa.Commands.Settings do
  alias Elppa.Command
  alias Nostrum.Api

  @behaviour Command
  @impl Command
  def spec(name), do: %{name: name, description: "修改設定"}

  @impl Command
  def handle_interaction(interaction) do
    Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Settings!"}
    })
  end
end
