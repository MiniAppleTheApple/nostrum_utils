defmodule Mark.Commands.Mark.Role.Set do
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Mark.SubCommand

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "設定可以使用改名功能的身份組",
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
