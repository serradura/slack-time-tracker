module SlashCommand
  class Invoke
    COMMANDS = {cache: nil}

    def self.setup(commands)
      COMMANDS[:cache] ||= CommandsContainer.new(commands)
    end

    def self.commands
      COMMANDS[:cache]
    end

    def self.command_with(params)
      new(params).command.tap(&:call)
    end

    def initialize(params)
      @payload = Payload.new(params)
      @validator = PayloadValidator.new(@payload)
      @parsed_command = CommandParser.new(params[:text])
    end

    def command
      strategy = @validator.ok? ? fetch_command : Commands::TokenError
      strategy.new(@payload, @parsed_command)
    end

    private

    def fetch_command
      self.class.commands.fetch(@parsed_command.name)
    end
  end
end
