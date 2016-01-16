# frozen_string_literal: true

module SlashCommand
  module Commands
    class In < Template
      HELP = "Start the timer for a new activity. Usage: `/tt in [NOTE]"
      

      EMPTY_NOTE_MSG = "You need a note to this activity!"
      NEW_ACTIVITY_CREATED = "You have just started working on a new activity. Keep going."
      STOPED_LAST_CREATED_NEW = "The previous activity was stopped and the next one just started."

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

        result_with_activity
      end

      def result_with_activity
        message = if user.stop_running_activity
                    STOPED_LAST_CREATED_NEW
                  else
                    NEW_ACTIVITY_CREATED
                  end

        user.time_entries.create(date: Date.current, start: Time.current, note: data)

        message
      end
    end
  end
end
