# frozen_string_literal: true

module SlashCommand
  module Commands
    class Display < Template
      NO_HISTORY_ACTIVITY = "You didn`t do anything today, you lazy! :stuck_out_tongue_closed_eyes:"
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Show all activities in history.
        usage: `/tt in [NOTE]`
      COMMAND_DESCRIPTION

      def self.description
        "Display all entries information.".freeze
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return NO_HISTORY_ACTIVITY unless user.time_entries.exists?

        show_recent_time_entries
      end

      def show_recent_time_entries
        "#{recent_time_entries_header}\n#{recent_time_entries_body}"
      end

      def recent_time_entries_header
        "\t\tDate\t\t|\t\tStart\t\t|\t\tEnd\t\t|\t\tRange\t\t|\t\tNote" 
      end

      def recent_time_entries_body
        recent_time_entries
          .map(&:to_display)
          .join("\n")
          .strip
      end

      def recent_time_entries
        user.time_entries.order(date: :desc, start: :asc).limit(50)
      end      
    end
  end
end
