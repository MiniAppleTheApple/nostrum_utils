defmodule Elppa.Settings do
  alias Nostrum.Struct.Embed
  alias Nostrum.Struct.Component
  alias Nostrum.Struct.Component.Button

  defstruct embed: nil, buttons: []

  @type t :: %__MODULE__{embed: Embed, buttons: [Component]}
  
  @limit %{
    "embed.title" => 256,
    "embed.description" => 4096,
    "field.name" => 256,
    "field.value" => 1024,
  }

  def required(map, attributes, prefix \\ "") when is_map(map) do
    attributes
    |> Enum.flat_map(fn x ->
      if map[x] == nil do
        [{:attribute_not_found, "#{prefix}#{x}"}]
      else
        []
      end
    end)
  end

  def valid_style_code?(x) when is_integer(x) and x not in 1..5, do: [:invalid_style_code]
  def valid_style_code?(_), do: []
  
  def valid_link_button?(%{"style" => 5, "url" => url}), do: [] 
  def valid_link_button?(%{"style" => 5}), do: [:invalid_link_button]
  def valid_link_button?(_), do: []

  def string_length_passed_the_limit?(key, value, limit) when is_binary(value) do
    length = String.length(value)
    if length > limit, do: [{:string_length_passed_the_limit, key, limit}], else: []
  end
  def string_length_passed_the_limit?(_, _, _), do: [] 

  def not_a_color?(color) when is_integer(color), do: if color > 0xffffff or color < 0, do: [:not_a_color], else: []
  def not_a_color?(_), do: []

  
  def not_a_boolean?(_, x) when is_boolean(x) or is_nil(x), do: []
  def not_a_boolean?(attribute, _), do: [{:not_a_boolean, attribute}]

  def not_a_string?(_, x) when is_binary(x) or is_nil(x), do: []
  def not_a_string?(attribute, _), do: [{:not_a_string, attribute}]

  def not_a_list?(_, x) when is_list(x) or is_nil(x), do: []
  def not_a_list?(attribute, _), do: [{:not_a_list, attribute}]
  
  def not_a_link?(attribute, link) when is_bitstring(link), do: if String.starts_with?(link, ["https://", "http://"]), do: [], else: [{:not_a_link, attribute}]
  def not_a_link?(_, _), do: []
  
  def not_a_int?(attribute, x) when is_integer(x) or is_nil(x), do: []
  def not_a_int?(attribute, _), do: [{:not_a_int, attribute}]

  def not_a_map?(attribute, x) when is_map(x) or is_nil(x), do: []
  def not_a_map?(attribute, _), do: [{:not_a_map, attribute}]

  def valid_button?({button, index}) when is_map(button), do: valid_style_code?(button["style"]) ++ valid_link_button?(button) ++ not_a_string?("buttons.#{index}.label", button["label"]) ++ not_a_int?("buttons.#{index}.style", button["style"]) ++ required(button, ["label", "style"], "buttons.#{index}.")
  def valid_button?({_, index}), do: [{:not_a_map, "buttons.#{index}"}]
  
  def valid_fields?(fields) when is_list(fields) do
    fields
    |> Enum.with_index()
    |> Enum.flat_map(fn {field, index} ->
      if is_map(field) do
        not_a_boolean?("embed.fields.#{index}.inline", field["inline"]) ++
        string_length_passed_the_limit?("embed.fields.#{index}.name", field["name"], @limit["field.name"]) ++
        string_length_passed_the_limit?("embed.fields.#{index}.value", field["value"], @limit["field.value"]) ++
        not_a_string?("embed.fields.#{index}.name", field["name"]) ++
        not_a_string?("embed.fields.#{index}.value", field["value"]) ++
        required(field, ["name", "value"], "embed.fields.#{index}.")
      else
        [{:not_a_map, "embed.fields.#{index}"}]
      end
    end)
  end
  def valid_fields?(fields), do: not_a_list?("embed.fields", fields) 

  def valid_footer?(attribute, footer) when is_map(footer) do
    not_a_link?("#{attribute}.icon_url", footer["icon_url"]) ++
    not_a_string?("#{attribute}.icon_url", footer["icon_url"]) ++
    not_a_string?("#{attribute}.text", footer["text"]) ++
    required(footer, ["text"], "embed.footer.")  
  end
  def valid_footer?(attribute, footer), do: not_a_map?(attribute, footer) 

  def valid_image?(attribute, image) when is_map(image) do
    not_a_int?("#{attribute}.width", image["width"]) ++
    not_a_int?("#{attribute}.height", image["height"]) ++
    not_a_link?("#{attribute}.url", image["url"]) ++
    not_a_string?("#{attribute}.url", image["url"]) ++
    required(image, ["url"], "#{attribute}.")    
  end
  def valid_image?(attribute, image), do: not_a_map?(attribute, image) 

  def valid_embed?(embed) when is_map(embed) do
    Enum.flat_map(["title", "description"], fn x ->
      not_a_string?("embed.#{x}", embed[x])
    end) ++
    valid_fields?(embed["fields"]) ++
    string_length_passed_the_limit?("embed.title", embed["title"], @limit["embed.title"]) ++
    string_length_passed_the_limit?("embed.description", embed["description"], @limit["embed.description"]) ++
    not_a_color?(embed["color"]) ++
    not_a_int?("embed.color", embed["color"]) ++ 
    valid_image?("embed.thumbnail", embed["thumbnail"]) ++
    valid_image?("embed.image", embed["image"]) ++
    valid_footer?("embed.footer", embed["footer"])    
  end
  def valid_embed?(embed), do: not_a_map?("embed", embed) 
 
  def map_key_to_atom(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} -> 
      cond do
        is_map(value) -> {String.to_atom(key), map_key_to_atom(value)}
        is_list(value) -> {String.to_atom(key), value |> Enum.flat_map(fn x -> 
          if is_map(x) do
            [map_key_to_atom(x)]
          else
            []
          end
        end)}
        true -> {String.to_atom(key), value}
      end
    end)
    |> Enum.into(%{})
  end
  
  def from_map_to_embed(embed) when is_map(embed) do
    new = struct(Embed, map_key_to_atom(embed))
    %Embed{new | thumbnail: struct(Embed.Image, new.thumbnail), image: struct(Embed.Image, new.image), fields: new.fields |> Enum.map(&struct(Embed.Field, &1)), footer: struct(Embed.Footer, new.footer)}
  end

  @spec from_map(map) :: t
  def from_map(%{"embed" => embed, "buttons" => buttons}) when is_map(embed) do
    %__MODULE__{embed: from_map_to_embed(embed), buttons: Enum.map(buttons, fn x -> Button.button(map_key_to_atom(x)) end)}
  end

  def valid_buttons?(buttons) when is_list(buttons) do
    buttons
    |> Enum.with_index()
    |> Enum.flat_map(&valid_button?/1)
  end

  def valid_buttons?(_), do: [{:not_a_list, "buttons"}]

  @spec new(map) :: {:ok, t} | :error
  def new(data = %{"embed" => embed, "buttons" => buttons}) do
    errors = valid_embed?(embed) ++ valid_buttons?(buttons) 
    if errors == [] do
      {:ok, from_map(data)} 
    else
      {:error, errors}
    end
  end

  def new(data), do: {:error, required(data, ["buttons", "embed"], "")}
end
