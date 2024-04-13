defmodule Mark.Commands.Mark.Role.Set do
  alias Nostrum.Constants.InteractionCallbackType
  alias Nostrum.Api
  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Mark.SubCommand
  alias Mark.CommandOption
  alias Mark.Repo
  alias Mark.Schema.Server
  alias Mark.Schema.Role

  import Bitwise
  import Ecto.Query

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "設定可以使用改名功能的身份組",
      type: ApplicationCommandOptionType.sub_command(),
      options: [
        %{
          name: "roles",
          description: "您想要新增的身份組（使用\",\"分開）",
          type: ApplicationCommandOptionType.string(),
        },
      ]
    }
  end

  @impl SubCommand
  def handle_interaction(interaction, option) do
    guild_roles = interaction.guild_id
    |> Nostrum.Api.get_guild_roles!()
    |> Enum.map(fn role ->
      {role.name, role.id}
    end)
    |> Enum.into(%{})

    roles = option
    |> CommandOption.get_option("roles")
    |> String.split(",")
    
    
    query = from s in Server, where: s.ref == ^(interaction.guild_id |> to_string()), preload: [:needed_roles], select: s

    case Repo.all(query) do
      [] ->
        Api.create_interaction_response!(interaction, %{
          type: InteractionCallbackType.channel_message_with_source(),
          data: %{
            flag: 1 <<< 6, #empheral
            content: "此伺服器未被設定，請使用`/mark set`來設定",
          },
        })
      [server | _rest] ->
        roles_id = roles
        |> Enum.map(fn role_name ->
          v = guild_roles[role_name]
          if v == nil do
            throw "error"
          else
            v
          end
        end)

        needed_roles = server.needed_roles
        |> Enum.map(fn %Role{ref: ref} ->
          ref
        end)
        |> MapSet.new()

        roles_set = roles_id
        |> MapSet.new()

        case MapSet.intersection(needed_roles, roles_set) |> MapSet.to_list() do
          [] -> 
            roles_id 
            |> Enum.each(fn role ->
              Repo.insert(%Role{ref: role |> to_string()})
            end)
          intersection_list ->
            Api.create_interaction_response!(interaction, %{
              type: InteractionCallbackType.channel_message_with_source(),
              data: %{
                flag: 1 <<< 6, #empheral
                content: "#{intersection_list |> Enum.join(",")}爲重複的",
              },
            })
        end
   

        
    end

    Api.create_interaction_response!(interaction, %{
      type: InteractionCallbackType.channel_message_with_source(),
      data: %{
        flag: 1 <<< 6, # empheral,
        content: "已將#{roles |> Enum.join("，")}身份組新增進可以使用改名指令的名單",
      }
    })
  end
end
