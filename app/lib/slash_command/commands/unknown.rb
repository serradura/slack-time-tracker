# frozen_string_literal: true

module SlashCommand
  module Commands
    class Unknown < Template
      HELP = "There’s no such command."

      def call
        response.result = HELP
      end
    end
  end
end
