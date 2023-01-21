defmodule Elppa.Commands.Settings do
  alias Elppa.Command
  alias Elppa.Settings

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Component.Button
  alias Nostrum.Struct.Component.ActionRow

  @behaviour Command
  @impl Command
  def spec(name), do: %{
    name: name,
    description: "Change the settings",
    options: [
      %{
        name: "file",
        description: "upload your file",
        type: 11,
        required: true,
      }
    ],
  }

  @impl Command
  def handle_interaction(interaction) do
    IO.puts("Hello")
    method = :get
    headers = []
    payload = ""
    options = []

    # 先找到對應的attachment之後取得url
    # 發送request到該url並且讀取body
    with %Nostrum.Struct.Message.Attachment{url: url} <- 
      Map.get(interaction.data.resolved.attachments, List.first(interaction.data.options).value),
    {:ok, _status_code, _resp_headers, client_ref} <-
      :hackney.request(method, url, headers, payload, options),
    {:ok, body} <-
      :hackney.body(client_ref) do
      
      {:ok, serialized_data} = Toml.decode(body)
      
      IO.puts("Hello")
      case Settings.new(serialized_data) do
        {:ok, data} ->
          Elppa.DB.save(data)
          IO.inspect(data)

          Api.create_interaction_response!(interaction, %{
            type: 4,
            data: %{
              embeds: [data.embed],
              components: [
                ActionRow.action_row() |> ActionRow.put_new(data.buttons),
              ]
            }
          })
        {:error, errors} ->
          Api.create_interaction_response!(interaction, %{
            type: 4,
            data: %{
              content: inspect(errors), 
            },
          })
      end
    else
      err -> 
        IO.inspect(err)
        Api.create_interaction_response(interaction, %{
          type: 4,
          data: %{
            content: "出錯",
          },
        }) 
    end
  end
end
