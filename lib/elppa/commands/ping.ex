defmodule Elppa.Commands.Ping do
  alias Nostrum.Api
  alias Elppa.Command

  @behaviour Command
  
  @impl Command
  def spec(name) do
    %{
      name: name,
      description: "A simple health check"
    }
  end

  @impl Command
  def handle_interaction(interaction) do
    Api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Pong!"}
    })
  end
end
