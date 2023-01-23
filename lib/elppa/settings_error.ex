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
  def to_string(:invalid_link_button) do
    ~s(
[資料錯誤] 鏈接按鈕必須附帶url。
+ 修復方法
  [[buttons]]
  style = 5
	label = "Example link button"
+ url = "https://cdn.shopify.com/s/files/1/0280/3931/5529/products/TH80ISO_1_06acecf8-138e-4113-a413-02ca33741e01.jpg?v=1666581520")
  end

  def to_string(:invalid_style_code) do
    ~s(
[資料錯誤] style必須為1到5的數字。
- 錯誤示範
	[[buttons]]
	style = 6
	label = "Example blue button"
	custom_id = "1"
+ 正確示範
  [[buttons]]
	style = 1
	label = "Example blue button"
	custom_id = "1")
  end

  def to_string({:string_length_passed_limit, attribute, limit}) do
    "\n[資料錯誤] #{attribute}不能超過#{limit}個字數"
  end

  def to_string(:not_a_color) do
    "\n[資料錯誤] color必須為顏色，如: 0xffffff、0x3A868F、0x6E3A8F等等。"
  end

  def to_string({:not_a_link, attribute}) do
    "\n[資料錯誤] #{attribute}必須為鏈接，前面必須由https://或http://開始。"
  end

  def to_string({:attribute_not_found, attribute}) do
    "\n[資料錯誤] 未能找到#{attribute}，請檢查你的格式是否符合。"
  end

  def to_string({:not_a_string, attribute}) do
    "\n[資料錯誤] #{attribute}必須為文字，如 \"Hello\"、\"World\"等等。"
  end

  def to_string({:not_a_list, attribute}) do
    ~s(
[資料錯誤] #{attribute}必須為列表
+ 正確演示
[[buttons]]
	style = 1
	label = "Example blue button"
	custom_id = "1"
	
[[buttons]]
  style = 2
  label = "Example grey button"
  custom_id = "2"
- 注意 這個錯誤訊息過於通常，只是單純舉個列表的例子，請按照範例的為準。)
  end

  def to_string({:not_a_boolean, attribute}) do
    "\n[資料錯誤] #{attribute}必須為true或false。"
  end

  def to_string({:not_a_map, attribute}) do
    ~s(
[資料錯誤] #{attribute}必須為Map
+ 正確演示
[embed.image]
url = "https://cdn.shopify.com/s/files/1/0280/3931/5529/products/TH80ISO_1_06acecf8-138e-4113-a413-02ca33741e01.jpg?v=1666581520"
width = 500
height = 500
- 注意 這個錯誤訊息過於通常，只是單純舉個列表的例子，請按照範例的為準。)
  end

  def to_string({:not_a_int, attribute}) do
    "
[資料錯誤] #{attribute}必須為整數。"
  end
end
