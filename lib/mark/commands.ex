defmodule Mark.Commands do
  alias Mark.CommandRouter

  alias Nostrum.Struct.Interaction
  alias Nostrum.Constants.ApplicationCommandOptionType
  alias Nostrum.Constants.ApplicationCommandType

  @doc """
  Handling and routing for commands and interactions.
  """

  # Add your commands here. The command name will be passed as an argument to
  # your command's `spec/1` function, so you can see all of the command names
  # here and ensure they don't collide.
  @commands %{
    "mark" => %CommandRouter{
      level: :root,
      spec: %{
        name: "mark",
        type: ApplicationCommandType.chat_input(),
        description: "Root of all the commands"
      },
      commands: %{
        "set" => Mark.Commands.Mark.Set,
        "name" => %CommandRouter{
          level: :sub_command_group,
          spec: %{
            name: "name",
            type: ApplicationCommandOptionType.sub_command_group(),
            description: "設定名字相關的設定"
          },
          commands: %{
            "set" => Mark.Commands.Mark.Name.Set,
            "delset" => Mark.Commands.Mark.Name.DelSet,
            "black" => Mark.Commands.Mark.Name.Black,
            "delblack" => Mark.Commands.Mark.Name.DelBlack
          }
        },
        "role" => %CommandRouter{
          level: :sub_command_group,
          spec: %{
            name: "role",
            type: ApplicationCommandOptionType.sub_command_group(),
            description: "設定可以使用修改名稱的身份組"
          },
          commands: %{
            "set" => Mark.Commands.Mark.Role.Set,
            "delset" => Mark.Commands.Mark.Role.DelSet
          }
        }
      }
    },
    "ping" => Mark.Commands.Ping
  }

  def register_commands do
    commands =
      for {name, command} <- @commands do
        if is_map(command) do
          CommandRouter.to_spec(command)
        else
          command.spec(name)
        end
      end

    # Global application commands take a couple of minutes to update in Discord,
    # so we use a test guild when in dev mode.
    if Application.get_env(:mark, :env) == :dev do
      IO.puts("Dev mode")
      guild_id = Application.get_env(:mark, :dev_guild_id)
      {:ok, _data} = Nostrum.Api.bulk_overwrite_guild_application_commands(guild_id, commands)
    else
      Nostrum.Api.bulk_overwrite_global_application_commands(commands)
    end
  end

  def handle_interaction(interaction) do
    command = Map.get(@commands, interaction.data.name)

    if command == nil do
      :ok
    else
      if match?(%CommandRouter{}, command) do
        {:ok, {command_mod, option}} = CommandRouter.direct(command, interaction)
        command_mod.handle_interaction(interaction, option)
      else
        command.handle_interaction(interaction)
      end
    end
  end
end
