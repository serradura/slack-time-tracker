# frozen_string_literal: true

module SlashCommand
  module Commands
    class Unknown < Template
      UNKNOWN_COMMAND = "There’s no such command."

      def call
        response.result = UNKNOWN_COMMAND
      end
    end
  end
end
