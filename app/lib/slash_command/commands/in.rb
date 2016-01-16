# frozen_string_literal: true

module SlashCommand
  module Commands
    class In < Template
      HELP = <<-COMMAND_DESCRIPTION.strip_heredoc.freeze
        Start the timer for the current timesheet.
        usage: `/tt in [NOTE]`
      COMMAND_DESCRIPTION

      EMPTY_NOTE_MSG = "You need a note to this activity!"
      NEW_ACTIVITY_CREATED = "A new activity entry was created!"
      STOPED_LAST_CREATED_NEW = "The last activity was stoped and new one started!"

      def self.description
        "This command will start a new activity.".freeze
      end

      def call
        response.result = result
      end

      private

      def result
        return EMPTY_NOTE_MSG if data.blank?
        return HELP if help?
        return result_with_activity
      end

      def result_with_activity
        message = NEW_ACTIVITY_CREATED

        if user.stop_running_activity
          message = STOPED_LAST_CREATED_NEW
        end

        user.time_entries.create(date: Date.current, start: Time.current, note: data)

        message
      end
    end
  end
end
