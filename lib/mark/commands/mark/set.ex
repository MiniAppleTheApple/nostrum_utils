defmodule Mark.Commands.Mark.Set do
  alias Nostrum.Struct.Message
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
  alias Mark.MessageComponent
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
  def handle_interaction(interaction, _option) do
    id = MessageComponent.random_id()

    case Repo.all(from s in Server, where: s.ref == ^(interaction.guild_id |> to_string())) do
      [] ->
        MessageComponent.Agent.add_listener(id, fn interaction ->
          {:ok, server} = Repo.insert(%Server{ref: interaction.guild_id |> to_string()})
          role = Ecto.build_assoc(server, :needed_roles)
          Repo.insert(role)

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

          button = Button.interaction_button("進行修改", MessageComponent.random_id(), emoji: emoji)

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
          :ok
        end)
      # Api.create_interaction_response!(interaction, %{
      #   type: InteractionCallbackType.channel_message_with_source(),
      #   data: %{
      #     content: "正在爲您創建界面",
      #   },
      # })
      Api.create_interaction_response!(interaction, %{
        type: InteractionCallbackType.modal(),
        data: %{
          title: "常駐暱稱修改嵌入訊息設定",
          custom_id: id,
          components: [
            ActionRow.action_row(
              TextInput.text_input("訊息標題", MessageComponent.random_id(), required: true, min_length: 1, max_length: 4000)
            ),
            ActionRow.action_row(
              TextInput.text_input("訊息說明", MessageComponent.random_id(), required: true, min_length: 1, max_length: 4000, style: TextInputStyle.paragraph())
            ),
            ActionRow.action_row(
              TextInput.text_input("慾插入的圖片", MessageComponent.random_id())
            )
          ]
        }
      })
      servers ->
        IO.inspect(servers)
        Api.create_interaction_response!(interaction, %{
          type: 4,
          data: %{
            flags: 1 <<< 6, #ephemeral
            content: "你的伺服器已經存在一個界面了",
            components: []
          },
        })
    end
  end
end
