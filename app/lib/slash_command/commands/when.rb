module SlashCommand
  module Commands
    class When < Template
      NAME = "when"
      DESC = "This command will show the next events."
      
      HELP = <<-HELP.strip_heredoc.freeze
        Show the next events.
        usage: `/tt when`
      HELP

      TEMPLATE = <<-BODY.strip_heredoc.freeze
        The next Hey! event will be held on the 20th May from 7:30pm at The Belgrave in central Leeds.

        Hopefully see you then %{user_name}!

        http://hey.wearestac.com/
      BODY

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
