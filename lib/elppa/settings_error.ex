defmodule Elppa.SettingsError do
  @type attribute :: string
  @type limit :: integer
  @type t :: :invalid_link_button
    | :invalid_style_code 
    | {:string_length_passed_the_limit, attribute, limit}
    | :not_a_color
    | {:not_a_link, attribute}
    | {:attribute_not_found, attribute}
    | {:not_a_string, attribute}
    | {:not_a_list, attribute}
    | {:not_a_boolean, attribute}
    | {:not_a_map, attribute}
    | {:not_a_int, attribute}
  
  @spec to_string(t) :: String.t()
  def to_string({:invalid_link_button}) do
     
  end
end
