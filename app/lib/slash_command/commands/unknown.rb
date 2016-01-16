# frozen_string_literal: true

module SlashCommand
  module Commands
    class Unknown < Template
      def call
        response.result = "Unknown command :cry:"
      end
    end
  end
end
