defmodule Mark.Commands.Mark.Role.Set do
  alias Ecto.Queryable
  alias Nostrum.Struct.Component.{Button, ActionRow}
  alias Nostrum.Constants.{InteractionCallbackType, ApplicationCommandOptionType}
  alias Nostrum.Api

  alias Mark.{SubCommand, CommandOption, Repo, Util, Listeners}
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
          required: true,
        },
      ]
    }
  end

  @spec query_corresponding_server(String.t()) :: Queryable.t()
  defp query_corresponding_server(guild_id) do
    from s in Server, where: s.ref == ^(guild_id |> to_string()), preload: [:needed_roles], select: s
  end

  @spec intersection(list(), list()) :: list()
  defp intersection(set, other) do
    set
    |> MapSet.new()
    |> MapSet.intersection(other |> MapSet.new())
    |> MapSet.to_list()
  end

  @impl SubCommand
  def handle_interaction(interaction, option) do
    id_by_name = interaction.guild_id
    |> Nostrum.Api.get_guild_roles!()
    |> Enum.map(fn role ->
      {role.name, role.id}
    end)
    |> Enum.into(%{})

    name_by_id = id_by_name
    |> Enum.map(fn {name, id} ->
      {id, name}
    end)
    |> Enum.into(%{})

    roles = option
    |> CommandOption.get_option("roles")
    |> String.split(",")
    
    query = query_corresponding_server(interaction.guild_id)

    case Repo.one(query) do
      nil ->
        Api.create_interaction_response!(interaction, %{
          type: InteractionCallbackType.channel_message_with_source(),
          data: %{
            flags: 1 <<< 6, #empheral
            content: "此伺服器未被設定，請使用`/mark set`來設定",
          },
        })
      %{needed_roles: needed_roles} ->
        role_ids = roles
        |> Enum.map(fn role_name ->
          name_by_id[role_name]
        end)

        needed_role_ids = needed_roles
        |> Enum.map(fn %Role{ref: ref} ->
          ref
        end)
        
        case {
          intersection(role_ids, needed_role_ids) |> Enum.map(fn x -> name_by_id[x] end), # get the name of id
          roles |> Enum.filter(fn x -> id_by_name[x] == nil end), # filter roles that doesn't exist
        } do
          {[], []} -> 
            confirm_id = Util.random_id()
            confirm_btn = Button.interaction_button("確定", confirm_id)
            cancel_id = Util.random_id()
            cancel_btn = Button.interaction_button("取消", cancel_id)
            Api.create_interaction_response!(interaction, %{
              type: InteractionCallbackType.channel_message_with_source(),
              data: %{
                flags: 1 <<< 6, #empheral
                content: "確定進行此操作",
                components: [ActionRow.action_row() |> ActionRow.append(confirm_btn) |> ActionRow.append(cancel_btn)]
              },
            })
            Listeners.add_listener(confirm_id, fn interaction ->
              guild_id = interaction.guild_id |> Integer.to_string()
              server = Repo.one!(from s in Server, where: s.ref == ^guild_id, select: s)
              role_ids 
              |> Enum.each(fn role ->
                server                
                |> Ecto.build_assoc(:needed_roles, %{ref: role |> to_string()})
                |> Repo.insert()
              end)
              Api.create_interaction_response!(interaction, %{
                type: InteractionCallbackType.channel_message_with_source(),
                data: %{
                  flags: 1 <<< 6, # empheral,
                  content: "已將#{roles |> Enum.join("，")}身份組新增進可以使用改名指令的名單",
                }
              })
              :remove
            end)
            Listeners.add_listener(cancel_id, fn interaction ->
              Api.create_interaction_response!(interaction, %{
                type: InteractionCallbackType.channel_message_with_source(),
                data: %{
                  flag: 1 <<< 6, # empheral,
                  content: "動作取消",
                }
              })
              :remove
            end)
          {intersection_list, not_found_roles} ->
            repeated = if intersection_list == [], do: "", else: "#{intersection_list |> Enum.join(",")}爲重複的。"
            do_not_exist = if not_found_roles == [], do: "", else: "#{not_found_roles |> Enum.join(", ")}不存在。"

            Api.create_interaction_response!(interaction, %{
              type: InteractionCallbackType.channel_message_with_source(),
              data: %{
                flags: 1 <<< 6, #empheral
                content: "#{repeated}#{do_not_exist}",
              },
            })
        end
    end
  end
end
