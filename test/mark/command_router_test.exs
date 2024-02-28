defmodule Mark.Test.CommandRouter.SubCommand do
  alias Mark.SubCommand
  
  alias Nostrum.Constants.ApplicationCommandOptionType

  @behaviour SubCommand

  @impl SubCommand
  def spec(name) do
    %{
      name: name,
      type: ApplicationCommandOptionType.sub_command(),
      description: "description"
    }
  end

  @impl SubCommand
  def handle_interaction(_option) do
    :ok
  end
end

defmodule Mark.Test.CommandRouter do
  alias Nostrum.Constants.ApplicationCommandOptionType

  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.ApplicationCommandInteractionData

  alias Mark.CommandRouter
  alias Mark.Test.CommandRouter.SubCommand

  use ExUnit.Case

  setup_all do
    struct = %CommandRouter{
      level: :root,
      spec: %{
        name: "root",
        description: "description"
      },
      commands: %{
        "sub_command_group" => %CommandRouter{
          level: :sub_command_group,
          spec: %{
            description: "description"
          },
          commands: %{
            "sub_command" => SubCommand
          }
        }
      }
    }

    {:ok, %{struct: struct}}
  end

  test "Convert layer 3 depth command router to spec", %{struct: struct} do
    spec = %{
      name: "root",
      description: "description",
      options: [
        %{
          name: "sub_command_group",
          description: "description",
          type: ApplicationCommandOptionType.sub_command_group(),
          options: [
            %{
              name: "sub_command",
              description: "description",
              type: ApplicationCommandOptionType.sub_command()
            }
          ]
        }
      ]
    }

    assert CommandRouter.to_spec(struct) == spec
  end

  test "Convert layer 4 depth command router to spec" do
    struct = %CommandRouter{
      level: :root,
      spec: %{
        name: "root",
        description: "description"
      },
      commands: %{
        "sub_command_group_group" => %CommandRouter{
          level: :sub_command_group,
          spec: %{
            description: "description"
          },
          commands: %{
            "sub_command_group" => %CommandRouter{
              level: :sub_command_group,
              spec: %{
                description: "description"
              },
              commands: %{
                "sub_command" => SubCommand
              }
            }
          }
        }
      }
    }

    spec = %{
      name: "root",
      description: "description",
      options: [
        %{
          name: "sub_command_group_group",
          description: "description",
          type: ApplicationCommandOptionType.sub_command_group(),
          options: [
            %{
              name: "sub_command_group",
              description: "description",
              type: ApplicationCommandOptionType.sub_command_group(),
              options: [
                %{
                  name: "sub_command",
                  description: "description",
                  type: ApplicationCommandOptionType.sub_command()
                }
              ]
            }
          ]
        }
      ]
    }

    assert CommandRouter.to_spec(struct) == spec
  end

  test "Direct to correct command", %{struct: struct} do
    interaction = %Interaction{
      data: %ApplicationCommandInteractionData{
        name: "root",
        options: [
          %ApplicationCommandInteractionData{
            name: "sub_command_group",
            type: ApplicationCommandOptionType.sub_command_group(),
            options: [
              %ApplicationCommandInteractionData{
                name: "sub_command",
                type: ApplicationCommandOptionType.sub_command()
              }
            ]
          }
        ]
      }
    }

    assert CommandRouter.direct(struct, interaction) ==
             {:ok,
              {SubCommand,
               %ApplicationCommandInteractionData{
                 name: "sub_command",
                 type: ApplicationCommandOptionType.sub_command()
               }}}
  end
end
