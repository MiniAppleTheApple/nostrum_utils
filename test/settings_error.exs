defmodule Elppa.Test.SettingsError do
  use ExUnit.Case
  alias Elppa.SettingsError
  
  setup_all do
    {:ok, attribute: "example"} 
  end

  test "Invalid link button" do
    result = ~s(
[資料錯誤] 鏈接按鈕必須附帶url。
+ 修復方法
  [[buttons]]
  style = 5
	label = "Example link button"
+ url = "https://cdn.shopify.com/s/files/1/0280/3931/5529/products/TH80ISO_1_06acecf8-138e-4113-a413-02ca33741e01.jpg?v=1666581520")
    assert result == SettingsError.to_string(:invalid_link_button)
  end

  test "Invalid style code" do
    result = ~s(
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

    assert result == SettingsError.to_string(:invalid_style_code)
  end

  test "String length passed limit", %{attribute: attribute} do
    limit = 1
    result = "\n[資料錯誤] #{attribute}不能超過#{limit}個字數" 

    assert result == SettingsError.to_string({:string_length_passed_limit, attribute, limit})
  end

  test "Not a color" do
    result = "\n[資料錯誤] color必須為顏色，如: 0xffffff、0x3A868F、0x6E3A8F等等。"

    assert result == SettingsError.to_string(:not_a_color)
  end

  test "Not a link", %{attribute: attribute} do
    result = "\n[資料錯誤] #{attribute}必須為鏈接，前面必須由https://或http://開始。"

    assert result == SettingsError.to_string({:not_a_link, "example"})
  end

  test "Attribute not found", %{attribute: attribute} do
    result = "\n[資料錯誤] 未能找到#{attribute}，請檢查你的格式是否符合。"

    assert result == SettingsError.to_string({:attribute_not_found, "example"})
  end

  test "Not a string", %{attribute: attribute} do
    result = "\n[資料錯誤] #{attribute}必須為文字，如 \"Hello\"、\"World\"等等。"

    assert result == SettingsError.to_string({:not_a_string, "example"})
  end

  test "Not a list", %{attribute: attribute} do
    result = ~s(
[資料錯誤] #{attribute}必須為列表
+ 正確演示
[[buttons]]
	style = 1
	label = "Example blue button\"
	custom_id = "1"
	
[[buttons]]
  style = 2
  label = "Example grey button"
  custom_id = "2"
- 注意 這個錯誤訊息過於通常，只是單純舉個列表的例子，請按照範例的為準。)
    
    assert result == SettingsError.to_string({:not_a_list, attribute})
  end

  test "Not a boolean", %{attribute: attribute} do
    result = "
[資料錯誤] #{attribute}必須為true或false。"
    
    assert result == SettingsError.to_string({:not_a_boolean, attribute})
  end

  test "Not a map", %{attribute: attribute} do
    result = ~s(
[資料錯誤] #{attribute}必須為Map
+ 正確演示
[embed.image]
url = "https://cdn.shopify.com/s/files/1/0280/3931/5529/products/TH80ISO_1_06acecf8-138e-4113-a413-02ca33741e01.jpg?v=1666581520"
width = 500
height = 500
- 注意 這個錯誤訊息過於通常，只是單純舉個列表的例子，請按照範例的為準。)

    assert result == SettingsError.to_string({:not_a_map, attribute})
  end

  test "Not a int", %{attribute: attribute} do
    result = "\n[資料錯誤] #{attribute}必須為整數。"

    assert result == SettingsError.to_string({:not_a_int, attribute})
  end
end
