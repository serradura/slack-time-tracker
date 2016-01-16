# frozen_string_literal: true

module SlashCommand
  module Commands
    class TokenError < Template
      def call
        response.result = "Invalid slack token :astonished:"
      end
    end
  end
end
