defmodule Elppa.Test.Settings do
  use ExUnit.Case

  alias Elppa.Settings
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Component

  @example %{
   "buttons" => [
     %{"label" => "Example blue button", "style" => 1},
     %{"label" => "Example grey button", "style" => 2},
     %{"label" => "Example green button", "style" => 3},
     %{"label" => "Example red button", "style" => 4},
     %{
       "label" => "Example link button",
       "style" => 5,
       "url" => "https://www.example.com"
     }
   ],
   "embed" => %{
     "author" => %{"name" => "Author name", "url" => "http://www.example.com"},
     "color" => 0xffffff,
     "description" => "Example Description",
     "fields" => [
       %{
         "inline" => true,
         "name" => "example field",
         "value" => "example value"
       },
       %{
         "inline" => false,
         "name" => "example field",
         "value" => "example value"
       }
     ],
     "footer" => %{"icon_url" => "http://www.example.com", "text" => "Footer"},
     "image" => %{
       "height" => 500,
       "url" => "http://www.example.com",
       "width" => 500
     },
     "thumbnail" => %{
       "height" => 500,
       "url" => "http://www.example.com",
       "width" => 500
     },
     "title" => "Example Title"
   }
 }

  @serialized %Elppa.Settings{
    buttons: [
      %Nostrum.Struct.Component{
        components: nil,
        custom_id: nil,
        disabled: false,
        emoji: nil,
        label: "Example blue button",
        max_length: nil,
        max_values: nil,
        min_length: nil,
        min_values: nil,
        options: nil,
        placeholder: nil,
        required: nil,
        style: 1,
        type: 2,
        url: nil,
        value: nil
      },
      %Nostrum.Struct.Component{
        components: nil,
        custom_id: nil,
        disabled: false,
        emoji: nil,
        label: "Example grey button",
        max_length: nil,
        max_values: nil,
        min_length: nil,
        min_values: nil,
        options: nil,
        placeholder: nil,
        required: nil,
        style: 2,
        type: 2,
        url: nil,
        value: nil
      },
      %Nostrum.Struct.Component{
        components: nil,
        custom_id: nil,
        disabled: false,
        emoji: nil,
        label: "Example green button",
        max_length: nil,
        max_values: nil,
        min_length: nil,
        min_values: nil,
        options: nil,
        placeholder: nil,
        required: nil,
        style: 3,
        type: 2,
        url: nil,
        value: nil
      },
      %Nostrum.Struct.Component{
        components: nil,
        custom_id: nil,
        disabled: false,
        emoji: nil,
        label: "Example red button",
        max_length: nil,
        max_values: nil,
        min_length: nil,
        min_values: nil,
        options: nil,
        placeholder: nil,
        required: nil,
        style: 4,
        type: 2,
        url: nil,
        value: nil
      },
      %Nostrum.Struct.Component{
        components: nil,
        custom_id: nil,
        disabled: false,
        emoji: nil,
        label: "Example link button",
        max_length: nil,
        max_values: nil,
        min_length: nil,
        min_values: nil,
        options: nil,
        placeholder: nil,
        required: nil,
        style: 5,
        type: 2,
        url: "https://www.example.com",
        value: nil
      }
    ],
    embed: %Nostrum.Struct.Embed{
      author: %{name: "Author name", url: "http://www.example.com"},
      color: 0xffffff,
      description: "Example Description",
      fields: [
        %Nostrum.Struct.Embed.Field{
          inline: true,
          name: "example field",
          value: "example value"
        },
        %Nostrum.Struct.Embed.Field{
          inline: false,
          name: "example field",
          value: "example value"
        }
      ],
      footer: %Nostrum.Struct.Embed.Footer{icon_url: "http://www.example.com", text: "Footer", proxy_icon_url: nil},
      image: %Nostrum.Struct.Embed.Image{height: 500, url: "http://www.example.com", width: 500, proxy_url: nil},
      provider: nil,
      thumbnail: %Nostrum.Struct.Embed.Image{
        height: 500,
        url: "http://www.example.com",
        width: 500,
        proxy_url: nil,
      },
      timestamp: nil,
      title: "Example Title",
      type: nil,
      url: nil,
      video: nil
    }
  }

  defp duplicate_a(length), do: "a" |> List.duplicate(length) |> Enum.join("")

  test "Data serialization" do
    {:ok, data} = Settings.new(@example)
    assert data == @serialized
  end

  test "embed" do
    assert {:error, [{:not_a_map, "embed"}]} == Settings.new(@example |> Map.put("embed", 0))
  end

  test "embed.title" do
    embed = @example["embed"]
    embed = embed |> Map.put("title", 0)
    assert {:error, [{:not_a_string, "embed.title"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    embed = embed |> Map.put("title", duplicate_a(257))
    assert {:error, [{:string_length_passed_the_limit, "embed.title", 256}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.description" do
    embed = @example["embed"]
    embed = embed |> Map.put("description", 0)
    assert {:error, [{:not_a_string, "embed.description"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    embed = embed |> Map.put("description", duplicate_a(4097))
    assert {:error, [{:string_length_passed_the_limit, "embed.description", 4096}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.color" do
    embed = @example["embed"]
    embed = embed |> Map.put("color", "")
    assert {:error, [{:not_a_int, "embed.color"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    embed = embed |> Map.put("color", -1)
    assert {:error, [:not_a_color]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.thumbnail" do
    embed = @example["embed"]
    embed = embed |> Map.put("thumbnail", 0)
    assert {:error, [{:not_a_map, "embed.thumbnail"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.thumbnail.url" do
    embed = @example["embed"]
    
    thumbnail = embed["thumbnail"] |> Map.put("url", 0)
    embed = embed |> Map.put("thumbnail", thumbnail)
    assert {:error, [{:not_a_string, "embed.thumbnail.url"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    thumbnail = thumbnail |> Map.put("url", "")
    embed = embed |> Map.put("thumbnail", thumbnail)
    assert {:error, [{:not_a_link, "embed.thumbnail.url"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.thumbnail.width" do
    embed = @example["embed"]

    thumbnail = embed["thumbnail"] |> Map.put("width", "")
    embed = embed |> Map.put("thumbnail", thumbnail)
    assert {:error, [{:not_a_int, "embed.thumbnail.width"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.thumbnail.height" do
    embed = @example["embed"]

    thumbnail = embed["thumbnail"] |> Map.put("height", "")
    embed = embed |> Map.put("thumbnail", thumbnail)
    assert {:error, [{:not_a_int, "embed.thumbnail.height"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.image" do
    embed = @example["embed"]
    embed = embed |> Map.put("image", 0)
    assert {:error, [{:not_a_map, "embed.image"}]} == Settings.new(@example |> Map.put("embed", embed))
  end
  
  test "embed.image.url" do
    embed = @example["embed"]
    
    image = embed["image"] |> Map.put("url", 0)
    embed = embed |> Map.put("image", image)
    assert {:error, [{:not_a_string, "embed.image.url"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    image = image |> Map.put("url", "")
    embed = embed |> Map.put("image", image)
    assert {:error, [{:not_a_link, "embed.image.url"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.image.width" do
    embed = @example["embed"]

    image = embed["image"] |> Map.put("width", "")
    embed = embed |> Map.put("image", image)
    assert {:error, [{:not_a_int, "embed.image.width"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.image.height" do
    embed = @example["embed"]

    image = embed["image"] |> Map.put("height", "")
    embed = embed |> Map.put("image", image)
    assert {:error, [{:not_a_int, "embed.image.height"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.footer" do
    embed = @example["embed"] |> Map.put("footer", 0)

    assert {:error, [{:not_a_map, "embed.footer"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.footer.icon_url" do
    embed = @example["embed"]
    
    footer = embed["footer"] |> Map.put("icon_url", 0)
    embed = embed |> Map.put("footer", footer)
    assert {:error, [{:not_a_string, "embed.footer.icon_url"}]} == Settings.new(@example |> Map.put("embed", embed))
    
    footer = footer |> Map.put("icon_url", "")
    embed = embed |> Map.put("footer", footer)
    assert {:error, [{:not_a_link, "embed.footer.icon_url"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.footer.text" do
    embed = @example["embed"]
    
    footer = embed["footer"] |> Map.put("text", 0)
    embed = embed |> Map.put("footer", footer)
    assert {:error, [{:not_a_string, "embed.footer.text"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.fields" do
    embed = @example["embed"]
    embed = embed |> Map.put("fields", 0)
    assert {:error, [{:not_a_list, "embed.fields"}]} == Settings.new(@example |> Map.put("embed", embed))
  end

  test "embed.fields.#" do
    embed = @example["embed"]
    embed = embed |> Map.put("fields", [0])
    assert {:error, [{:not_a_map, "embed.fields.0"}]} == Settings.new(@example |> Map.put("embed", embed))
    field = %{
      "name" => 0,
      "value" => 0,
      "inline" => 0,
    }

    embed = embed |> Map.put("fields", [field])
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new([{:not_a_string, "embed.fields.0.name"}, {:not_a_string, "embed.fields.0.value"}, {:not_a_boolean, "embed.fields.0.inline"}])
    assert MapSet.equal?(set, expected)
  
    field = %{
      "name" => duplicate_a(257),
      "value" => duplicate_a(1025),
      "inline" => false,
    }
    embed = embed |> Map.put("fields", [field])
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new([{:string_length_passed_the_limit, "embed.fields.0.name", 256}, {:string_length_passed_the_limit, "embed.fields.0.value", 1024}])
    assert MapSet.equal?(set, expected)
  end

  test "buttons" do
    assert {:error, [{:not_a_list, "buttons"}]} == Settings.new(@example |> Map.put("buttons", 0))
  end

  test "buttons.#" do
    assert {:error, [{:not_a_map, "buttons.0"}]} == Settings.new(@example |> Map.put("buttons", [0]))
    button = %{
      "style" => "",
      "label" => 0,
    }
    {:error, msgs} = Settings.new(@example |> Map.put("buttons", [button]))
    set = MapSet.new(msgs)
    expected = MapSet.new([{:not_a_int, "buttons.0.style"}, {:not_a_string, "buttons.0.label"}])
    assert MapSet.equal?(set, expected)
    
    button = %{
      "style" => 6,
      "label" => "",
    }
    assert {:error, [:invalid_style_code]} == Settings.new(@example |> Map.put("buttons", [button]))

    button = %{
      "style" => 5,
      "label" => "",
    }
    
    assert {:error, [:invalid_link_button]} == Settings.new(@example |> Map.put("buttons", [button]))
  end

  defp attributes_not_found(attributes, prefix), do: attributes |> Enum.map(&({:attribute_not_found, "#{prefix}#{&1}"})) 

  test "Missing attribute" do
    {:error, msgs} = Settings.new(%{})
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["embed", "buttons"], ""))
    assert MapSet.equal?(set, expected)
    
    embed = @example["embed"] |> Map.put("thumbnail", %{})
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["url"], "embed.thumbnail."))
    assert MapSet.equal?(set, expected)
    
    embed = @example["embed"] |> Map.put("image", %{})
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["url"], "embed.image."))
    assert MapSet.equal?(set, expected)

    embed = @example["embed"] |> Map.put("footer", %{})
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["text"], "embed.footer."))
    assert MapSet.equal?(set, expected)
    
    embed = @example["embed"] |> Map.put("fields", [%{}])
    {:error, msgs} = Settings.new(@example |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["value", "name"], "embed.fields.0."))
    assert MapSet.equal?(set, expected)

    {:error, msgs} = Settings.new(@example |> Map.put("buttons", [%{}]))
    set = MapSet.new(msgs)
    expected = MapSet.new(attributes_not_found(["style", "label"], "buttons.0."))
    assert MapSet.equal?(set, expected)
  end

  test "Missing value and wrong type" do
    embed = @example["embed"]
            |> Map.put("title", 0)
    {:error, msgs} = Settings.new(@example |> Map.delete("buttons") |> Map.put("embed", embed))
    set = MapSet.new(msgs)
    expected = MapSet.new([{:attribute_not_found, "buttons"}, {:not_a_string, "embed.title"}])
    assert MapSet.equal?(set, expected)
  end
end
