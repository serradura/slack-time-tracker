module SlashCommand
  class Invoke
    COMMANDS = {cache: nil}

    delegate :commands, to: :class

    def self.setup(commands)
      COMMANDS[:cache] ||= CommandsContainer.new(commands)
    end

    def self.commands
      COMMANDS[:cache]
    end

    def self.command_with(params)
      new(params).command_response
    end

    def initialize(params)
      @payload = Payload.new(params)
      @validator = PayloadValidator.new(@payload)
      @parsed_command = CommandParser.new(params[:text])
    end

    def command_response
      return @validator.error_response if @validator.error?

      fetch_command.tap(&:call).response
    end

    private

    def fetch_command
      strategy = commands.fetch(@parsed_command)
      strategy.new(@payload, @parsed_command)
    end
  end
end
