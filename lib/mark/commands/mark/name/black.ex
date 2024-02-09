defmodule Mark.Commands.Mark.Name.Black do
  alias Nostrum.Api

  alias Mark.SubCommand
  alias Mark.Constant.ApplicationCommandOptionType

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "將一個名字加入黑名單",
      type: ApplicationCommandOptionType.sub_command(),
      options: [
        %{
          name: "name",
          type: ApplicationCommandOptionType.string(),
          description: "你要加入黑名單的名字"
        }
      ]
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, _option) do
    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        content: "Ping"
      }
    })
  end
end
