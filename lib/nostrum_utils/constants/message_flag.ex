defmodule NostrumUtils.Constants.MessageFlag do
  import Bitwise 

  def crossposted(), do: 1 <<< 0 
  def is_crosspost(), do: 1 <<< 1
  def suppress_embeds(), do: 1 <<< 2
  def source_message_deleted(), do: 1 <<< 3
  def urgent(), do: 1 <<< 4
  def has_thread(), do: 1 <<< 5
  def emphemeral(), do: 1 <<< 6
  def loading(), do: 1 <<< 7
  def failed_to_mention_some_roles_in_thread(), do: 1 <<< 8
  def suppress_notifications(), do: 1 <<< 12
  def is_voice_message(), do: 1 <<< 13

  def add(current, flag), do: current ||| flag
end
