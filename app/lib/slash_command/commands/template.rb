module SlashCommand
  module Commands
    class Template
      attr_reader :payload, :response

      delegate :name, :help?, :data, to: :@parsed_command

      def initialize(payload, parsed_command)
        @payload = payload
        @response = SlashCommand::Response.new
        @parsed_command = parsed_command
      end

      def call
        fail NotImplementedError
      end
    end
  end
end
