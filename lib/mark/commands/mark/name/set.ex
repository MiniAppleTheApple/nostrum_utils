defmodule Mark.Commands.Mark.Name.Set do
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Mark.SubCommand

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "新增新的可以使用的字符格式",
      type: ApplicationCommandOptionType.sub_command(),
      options: []
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, _option) do
   
  end
end
