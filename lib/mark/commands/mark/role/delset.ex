defmodule Mark.Commands.Mark.Role.DelSet do
  alias Mark.SubCommand
  alias Mark.Constant.ApplicationCommandOptionType

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "移除本來可以使用改名功能的身份組",
      type: ApplicationCommandOptionType.sub_command(),
    } 
  end

  @impl SubCommand
  def handle_interaction(_interaction, _option) do

  end
end
