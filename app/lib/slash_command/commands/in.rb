# frozen_string_literal: true

module SlashCommand
  module Commands
    class In < Template
      HELP = "This command will start a new activity."
      EMPTY_NOTE_MSG = "You need a note to this activity!"
      NEW_ACTIVITY_CREATED = "A new activity entry was created!"

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
        user.time_entries.create(date: Date.current, start: Time.current, note: data)

        NEW_ACTIVITY_CREATED
      end
    end
  end
end
