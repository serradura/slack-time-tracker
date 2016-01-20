# frozen_string_literal: true

module SlashCommand
  module Commands
    class Default < Template
      NAME = "default"

      def call
        response.result = Help.help
      end
    end
  end
end
