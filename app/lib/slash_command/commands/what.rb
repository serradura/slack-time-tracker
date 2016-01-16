# frozen_string_literal: true

module SlashCommand
  module Commands
    class What < Template
      TEMPLATE = <<-BODY.strip_heredoc.freeze
        The next Hey! event has two lectures planned. The first one is with Rich Fiddaman discussing everything hospitality. The second is with Matt Dix discussing Leeds Indie Food Festival.

        http://hey.wearestac.com/lectures/a-pint-with-the-pub-landlord

        http://hey.wearestac.com/lectures/kickstarting-a-city-wide-food-festival
      BODY

      def call
        response.result = TEMPLATE
      end
    end
  end
end
