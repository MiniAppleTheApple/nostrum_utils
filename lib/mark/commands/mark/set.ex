defmodule Mark.Commands.Mark.Set do
  alias Mark.SubCommand
  alias Mark.Constant.ApplicationCommandOptionType

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "生成介面",
      type: ApplicationCommandOptionType.sub_command(),
    }   
  end

  @impl SubCommand
  def handle_interaction(_interaction, _option) do

  end
end 
  
