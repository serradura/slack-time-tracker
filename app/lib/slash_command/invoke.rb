# frozen_string_literal: true

module SlashCommand
  class Invoke
    COMMANDS = {
      "when" => Commands::When,
      "what" => Commands::What,
      "in"   => Commands::In,
      "out"  => Commands::Out
    }.update("help" => Commands::Help).freeze

    def self.command_with(params)
      new(params).command.tap(&:call)
    end

    def initialize(params)
      @payload = Payload.new(params)
      @validator = PayloadValidator.new(@payload)
      @parsed_command = CommandParser.new(params[:text])
    end

    def command
      strategy = @validator.ok? ? find_command : Commands::TokenError
      strategy.new(@payload, @parsed_command)
    end

    def find_command
      COMMANDS.fetch(@parsed_command.name, Commands::Unknown)
    end
  end
end
