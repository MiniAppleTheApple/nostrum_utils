defmodule Mark.Commands.Mark.Role.DelSet do
  alias Nostrum.Api

  alias Mark.SubCommand
  alias Mark.Constant.ApplicationCommandOptionType

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "移除本來可以使用改名功能的身份組",
      type: ApplicationCommandOptionType.sub_command()
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
