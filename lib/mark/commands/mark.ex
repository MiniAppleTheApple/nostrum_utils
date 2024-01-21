defmodule Mark.Commands.Mark do
  alias Nostrum.Api
  alias Nostrum.ApplicationCommandInteractionDataOption

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
          description: "設定UI",
          type: ApplicationCommandOptionType.sub_command(),
        },
        %{
          name: "name",
          description: "設定取名限制",
          type: ApplicationCommandOptionType.sub_command_group(),
          options: [
            %{
              name: "set",
              description: "新增新的可以使用的字符格式",
              type: ApplicationCommandOptionType.sub_command(),
              options: [
                %{
                  name: "type",
                  description: "字符格式的類型（用','把不同的字符格式代碼分開）",
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
    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        content: "Mark!",
      }
    }) 
  end
  
end
