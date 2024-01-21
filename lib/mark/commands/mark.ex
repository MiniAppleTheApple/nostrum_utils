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
          description: "生成介面",
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
                  description: "字符格式的類型",
                  type: ApplicationCommandOptionType.string(),a
                },
              ]
            },
            %{
              name: "delset",
              description: "刪除可以使用的字符格式",
              type: ApplicationCommandOptionType.sub_command(),
              options: [
                %{
                  name: "type",
                  description: "字符格式的類型"
                }
              ]
            },
            %{
              name: "black",
              description: "將一個名字加入黑名單",
              type: ApplicationCommandOptionType.sub_command()

              options: [
                %{
                  name: "name"
                  description: "你要加入黑名單的名字",
                }
              ]
            },
            %{
              name: "delblack",
              description: "將一個名字從黑名單移除",
              type: ApplicationCommandOptionType.sub_command_group(),

              options: [
                %{
                  name: "name",
                  description: "你要從黑名單移除的名字",
                }
              ]
            }
          ],
        },
        %{
          name: "test"
          description: "生成一個測試用的介面"
        },
        %{
          name: "log"
          description: "創建一個webhook用於記錄行爲",
        }
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
