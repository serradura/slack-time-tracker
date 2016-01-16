module SlashCommand
  module Commands
    class When < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Show the next events.
        usage: `/tt when`
      COMMAND_DESCRIPTION

      TEMPLATE = <<-BODY.strip_heredoc.freeze
        The next Hey! event will be held on the 20th May from 7:30pm at The Belgrave in central Leeds.

        Hopefully see you then %{user_name}!

        http://hey.wearestac.com/
      BODY

      def self.description
        "This command will show the next events.".freeze
      end

      def call
        response.result = result
      end

      def result
        if help?
          HELP
        else
          TEMPLATE % {user_name: user.name}
        end
      end
    end
  end
end
