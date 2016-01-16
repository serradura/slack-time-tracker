module SlashCommand
  module Commands
    class When < Template
      TEMPLATE = <<-BODY.strip_heredoc.freeze
        The next Hey! event will be held on the 20th May from 7:30pm at The Belgrave in central Leeds.

        Hopefully see you then %{user_name}!

        http://hey.wearestac.com/
      BODY

      def call
        response.result = TEMPLATE % {user_name: payload.user.name}
      end
    end
  end
end
