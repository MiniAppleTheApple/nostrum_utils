defmodule Mark.Commands.Mark.Name.DelBlack do
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Mark.SubCommand

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "將一個名字從黑名單移除",
      type: ApplicationCommandOptionType.sub_command(),
      options: [
        %{
          name: "name",
          type: ApplicationCommandOptionType.string(),
          description: "你要從黑名單移除的名字"
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
