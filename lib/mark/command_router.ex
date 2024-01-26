defmodule Mark.CommandRouter do
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.ApplicationCommandInteractionData
  alias Nostrum.Struct.ApplicationCommandInteractionDataOption

  alias Mark.Command
  alias Mark.Constant.ApplicationCommandOptionType

  @type level :: :root | :sub_command_group
  @type spec :: map()
  @type commands :: commands()

  @type t() :: %__MODULE__{
    level: level(),
    spec: spec(),
    commands: commands(),
  }

  @enforce_keys [:level, :spec, :commands]

  defstruct @enforce_keys

  @spec to_spec(Mark.CommandRouter.t()) :: map()
  def to_spec(%__MODULE__{level: :root, spec: spec, commands: commands}) do
    spec
    |> Map.put(:options,
      Enum.map(
        commands,
        fn {key, value} ->
          if is_map(value) do
            to_spec(
              value
              |> Map.get_and_update(
                :spec,
                &(
                  {
                    &1,
                    &1
                    |> Map.put(:name, key)
                  }
                )
              )
              |> elem(1)
            )
          else
            value.spec(key)
          end
        end
      )
    )
  end

  def to_spec(%__MODULE__{level: :sub_command_group, spec: spec, commands: commands}) do
    if commands
      |> Enum.any?(fn {_key, value} -> is_map(value) end)
    do
      spec
      |> Map.put(:type, ApplicationCommandOptionType.sub_command_group())
      |> Map.put(
        :options,
        commands
        |> Enum.map(fn {key, value} ->
          to_spec(value)
          |> Map.put(:name, key)
        end)
      )
    else
      options = for {name, command} <- commands, do: command.spec(name)
      spec
      |> Map.put(:type, ApplicationCommandOptionType.sub_command_group())
      |> Map.put(:options, options)
    end
  end

  @spec direct(t(), Interaction.t()) :: {:ok, {Command, ApplicationCommandInteractionDataOption}} | {:error, String.t()}
  def direct(router, %Interaction{data: data}) do
    direct(router, data)
  end

  @spec direct(t(), ApplicationCommandInteractionData.t() | ApplicationCommandInteractionDataOption.t()) :: {:ok, {Command, ApplicationCommandInteractionDataOption}} | {:error, String.t()}
  def direct(
    %__MODULE__{
      commands: commands,
    },
    data) do
    first = List.first(data.options)
    command = commands[first.name]
    if is_map(command) do
      command
      |> direct(first)
    else
      {:ok, {command, first}}
    end
  end
end