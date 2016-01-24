# frozen_string_literal: true

module SlashCommand
  module Commands
    class Edit < Template
      NAME = "edit"
      DESC = "This command will update the current activity note."
      HELP = <<-HELP.strip_heredoc.freeze
        Update the note of the current activity.
        usage: `/tt edit [NOTE]`
      HELP

      EMPTY_NOTE_MSG = "You need a note to this update!"
      ACTIVITY_EDITED = "The activity was updated!"
      ACTIVITY_NOT_RUNNING_MSG = "Hey, what's going on? Let's start an activity first! (e.g: `/tt in <NOTE>`)".freeze

      def call
        response.result = result
      end

      private

      def result
        return EMPTY_NOTE_MSG if data.blank?
        return ACTIVITY_NOT_RUNNING_MSG unless user.running_activity.present?

        update_activity
      end

      def update_activity
        user.running_activity.update_attribute(:note, data)

        ACTIVITY_EDITED
      end
    end
  end
end
