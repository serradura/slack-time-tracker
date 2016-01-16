# frozen_string_literal: true

module SlashCommand
  class Invoke
    COMMANDS = {
      "when" => Commands::When,
      "what" => Commands::What
    }.freeze

    def self.command_with(params)
      new(params).command.tap(&:call)
    end

    def initialize(params)
      @payload = Payload.new(params)
    end

    def command
      handler = @payload.valid? ? find_command : Commands::TokenError
      handler.new(@payload)
    end

    def find_command
      COMMANDS.fetch(@payload.command, Commands::Unknown)
    end
  end
end
