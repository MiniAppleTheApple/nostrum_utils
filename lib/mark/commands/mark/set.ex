defmodule Mark.Commands.Mark.Set do
  alias Nostrum.Struct.Emoji
  alias Nostrum.Struct.Component.Button
  alias Nostrum.Constants.TextInputStyle
  alias Nostrum.Api

  alias Nostrum.Constants.ApplicationCommandOptionType
  alias Nostrum.Constants.InteractionCallbackType

  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Component.TextInput
  alias Nostrum.Struct.Component.ActionRow

  alias Mark.SubCommand
  alias Mark.Listeners
  alias Mark.Util
  alias Mark.Repo

  alias Mark.Schema.Server

  alias Ecto

  import Ecto.Query, only: [from: 2]

  import Bitwise

  @timezone 8

  @behaviour SubCommand
  
  defp get_time, do: NaiveDateTime.utc_now() |> NaiveDateTime.add(@timezone, :hour)

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      description: "生成介面",
      type: ApplicationCommandOptionType.sub_command()
    }
  end

  defp format_time(time), do: "#{time.year}/#{time.month}/#{time.day} #{time.hour}:#{time.minute}"

  @impl SubCommand
  def handle_interaction(command_interaction, _option) do
    id = Util.random_id()
    
    # 從資料庫查看有沒有另外一個在此伺服器的界面
    case Repo.all(from s in Server, where: s.ref == ^(command_interaction.guild_id |> to_string())) do
      [] ->
        # Event binding 
        Listeners.add_listener(id, fn interaction ->
          # 將伺服器的資料放進資料庫
          name = Api.get_guild!(interaction.guild_id).name
          {:ok, server} = Repo.insert(%Server{ref: interaction.guild_id |> to_string(), name: name})

          # 取得用戶輸入
          [title, description, image_link] = interaction
          |> Util.get_textinputs_from_interaction()
          |> Enum.map(&(&1.value))

          current = get_time()

          emoji = %Emoji{name: "🤔"}

          embed = %Embed{}
          |> Embed.put_title(title)
          |> Embed.put_description(description)
          |> Embed.put_image(image_link)
          |> Embed.put_color(0x577CFF)
          |> Embed.put_footer("ZeiFrei × Mark bot ∣ 社群暱稱系統 • #{format_time(current)}", "https://avatars.githubusercontent.com/u/108135079?s=200&v=4")
         
          button_id = Util.random_id()
          button = Button.interaction_button("進行修改", button_id, emoji: emoji)

          button_handle = fn interaction ->
            query = from s in Server,
              where: s.ref == ^(interaction.guild_id |> Integer.to_string()),
              preload: [:needed_roles],
              select: s

            [%Server{needed_roles: needed_roles}] = Repo.all(query)

            needed_roles_id = needed_roles
            |> Enum.map(&(&1.ref))
            |> MapSet.new()

            roles_id = interaction.member.roles
            |> Enum.map(&Integer.to_string(&1))
            |> MapSet.new()

            if MapSet.subset?(needed_roles_id, roles_id) do
              modal_handle = fn interaction -> 
                [name] = interaction
                |> Util.get_textinputs_from_interaction()
                |> Enum.map(&(&1.value))

                case Api.modify_guild_member(interaction.guild_id, interaction.member.user_id, nick: name) do
                  {:ok, _member} ->
                    Api.create_interaction_response!(interaction, %{
                      type: InteractionCallbackType.channel_message_with_source(),
                      data: %{
                        flag: 1 <<< 6, # empheral
                        content: "你已經成功將名字修改成#{name}",
                      },
                    })    
                  {:error, _msg} ->
                    Api.create_interaction_response!(interaction, %{
                      type: InteractionCallbackType.channel_message_with_source(),
                      data: %{
                        flag: 1 <<< 6, # empheral
                        content: "無法修改你的名字，也許是此機器人的權限不足",
                      },
                    })
                end
                
                
                :ok
              end

              id = Util.random_id()

              Api.create_interaction_response!(interaction, %{
                type: InteractionCallbackType.modal(),
                data: %{
                  title: "修改暱稱",
                  custom_id: id,
                  components: [
                    ActionRow.action_row(
                      TextInput.text_input("你想要修改成的名字", Util.random_id(), required: true, min_length: 1, max_length: 4000))
                  ],
                },
              })
              {:add_listener, [{id, modal_handle}]}
            else
              Api.create_interaction_response(interaction, %{
                type: InteractionCallbackType.channel_message_with_source(),
                data: %{
                  content: "你不能使用此功能",
                },
              })
              :ok
            end
          end

          Api.create_interaction_response!(interaction, %{
            type: InteractionCallbackType.channel_message_with_source(),
            data: %{
              embeds: [embed],
              components: [
                ActionRow.action_row()
                |> ActionRow.append(button)
              ]
            }
          })

          {:add_listener, [{button_id, button_handle}]} 
        end)
        Api.create_interaction_response!(command_interaction, %{
          type: InteractionCallbackType.modal(),
          data: %{
           title: "常駐暱稱修改嵌入訊息設定",
           custom_id: id,
           components: [
             ActionRow.action_row(
               TextInput.text_input("訊息標題", Util.random_id(), required: true, min_length: 1, max_length: 4000)
             ),
             ActionRow.action_row(
               TextInput.text_input("訊息說明", Util.random_id(), required: true, min_length: 1, max_length: 4000, style: TextInputStyle.paragraph())
             ),
             ActionRow.action_row(
               TextInput.text_input("慾插入的圖片", Util.random_id())
             )
           ]
          }
        })
      servers ->
        IO.inspect(servers)
        Api.create_interaction_response!(command_interaction, %{
          type: 4,
          data: %{
            flags: 1 <<< 6, # ephemeral
            content: "你的伺服器已經存在一個介面了",
            components: []
          },
        })
    end
  end
end
