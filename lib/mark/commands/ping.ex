defmodule Mark.Commands.Ping do
  alias Nostrum.Api 

  alias Mark.Command
  
  @behaviour Command
  
  @impl Command
  def spec(name) do
    %{
      name: name,
      description: "A command to check if the bot is alive",
    } 
  end

  @impl Command
  def handle_interaction(interaction) do
    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        content: "Ping!",
      }
    }) 
  end

end
