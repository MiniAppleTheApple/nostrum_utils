defmodule Mark.Commands.Mark do
  alias Nostrum.Api
  
  alias Mark.Command
  alias Mark.Constant.ApplicationCommandOptionType

  @behaviour Command

  @impl Command
  def spec(name) do
    %{
      name: name,
      description: "Root of all the commands",
      options: [
        %{
          name: "set",
          description: "The command for setting up the ui",
          type: ApplicationCommandOptionType.sub_command(),
        },
        %{
          name: "name",
          type: ApplicationCommandOptionType.sub_command_group(),
          options: [
            %{
              name: "set",
              type: ApplicationCommandOptionType.sub_command(),
              options: [
                %{
                  name: "type",
                  type: ApplicationCommandOptionType.string(),
                }
              ]
            }
          ],
        },
      ],
    }
  end

  @impl Command
  def handle_interaction(interaction) do
    IO.inspect(interaction) 
  end
  
end
