defmodule Mark.Commands.Mark.Set do
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Mark.SubCommand

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "生成介面",
      type: ApplicationCommandOptionType.sub_command()
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, _option) do
    Api.create_interaction_response!(interaction, %{
      type: 4,
      data: %{
        components: [],
      }
    })
  end
end
