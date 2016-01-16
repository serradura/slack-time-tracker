# frozen_string_literal: true

module SlashCommand
  class Invoke
    COMMANDS_BUILDER = lambda do |tt_commands, test_commands|
      tt_commands.merge!(test_commands) unless Rails.env.production?
      tt_commands.freeze
    end

    TT_COMMANDS = {
      "in"  => Commands::In,
      "out" => Commands::Out,
      "now" => Commands::Now,
      "edit" => Commands::Edit,
      "kill" => Commands::Kill,
      "today" => Commands::Today,
      "display" => Commands::Display
    }.update("help" => Commands::Help)

    TEST_COMMANDS = {
      "when" => Commands::When,
      "what" => Commands::What
    }

    COMMANDS = COMMANDS_BUILDER.call(TT_COMMANDS, TEST_COMMANDS)

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
