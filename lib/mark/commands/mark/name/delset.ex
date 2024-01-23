defmodule Mark.Commands.Mark.Name.DelSet do
  alias Mark.SubCommand
  alias Mark.Constant.ApplicationCommandOptionType
  
  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "刪除可以使用的字符格式",
      type: ApplicationCommandOptionType.sub_command(),
      options: [
        %{
          name: "type",
          type: ApplicationCommandOptionType.string(),
          description: "字符格式的類型"
        }
      ]
    }
  end

  @impl SubCommand
  def handle_interaction(_interaction, _option) do
    
  end
end 
    
