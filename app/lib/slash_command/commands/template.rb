module SlashCommand
  module Commands
    class Template
      attr_reader :payload, :response

      def initialize(payload)
        @payload = payload
        @response = SlashCommand::Response.new
      end

      def call
        fail NotImplementedError
      end
    end
  end
end
