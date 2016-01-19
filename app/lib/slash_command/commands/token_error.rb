# frozen_string_literal: true

module SlashCommand
  module Commands
    class TokenError < Template
      ERROR = "Invalid slack token :astonished:"

      def call
        response.result = ERROR
      end
    end
  end
end
