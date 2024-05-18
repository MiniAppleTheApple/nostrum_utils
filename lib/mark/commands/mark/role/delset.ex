defmodule Mark.Commands.Mark.Role.DelSet do
  alias Nostrum.Struct.Component.ActionRow
  alias Nostrum.Api

  alias Nostrum.Constants.{ApplicationCommandOptionType, InteractionCallbackType}
  alias Nostrum.Struct.Component.SelectMenu
  alias Nostrum.Struct.Component.Option

  alias Mark.Util
  alias Mark.Listeners
  alias Mark.SubCommand
  alias Mark.Repo
  alias Mark.Schema.Role

  import Ecto.Query
  import Bitwise

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
    server = Repo.one!(Util.query_corresponding_server(interaction.guild_id, [:needed_roles]))  
    case server.needed_roles do
      [] ->
        Api.create_interaction_response!(interaction, %{
          type: InteractionCallbackType.channel_message_with_source(),
          data: %{
            flags: 1 <<< 6, #empheral
            content: "並沒有設定任何身份組",
          },
        })  
      needed_roles ->
        id = Util.random_id()
        roles = Api.get_guild_roles!(interaction.guild_id)
        |> Enum.map(fn role ->
          {role.id, role.name}
        end)
        |> Enum.into(%{})
        select_menu = SelectMenu.select_menu(id, [
          min_values: 1,
          max_values: needed_roles |> Enum.count(),
          options: needed_roles |> Enum.map(fn role ->
            %Option{
              label: roles[role.ref |> String.to_integer()],
              value: role.ref,
            }
          end)
        ])
        
        Listeners.add_listener(id, fn interaction ->
          values = interaction.data.values
          query = from r in Role, where: r.ref in ^values, select: r
          {count, _deleted} = Repo.delete_all(query)

          Api.create_interaction_response!(interaction, %{
            type: InteractionCallbackType.channel_message_with_source(),
            data: %{
              flags: 1 <<< 6, #empheral
              content: "已在設定中移除#{count}個身份組"
            }
          })
        end)

        Api.create_interaction_response!(interaction, %{
          type: InteractionCallbackType.channel_message_with_source(),
          data: %{
            flags: 1 <<< 6, #empheral
            components: [ActionRow.action_row(select_menu)]
          },
        })
    end
  end
end
