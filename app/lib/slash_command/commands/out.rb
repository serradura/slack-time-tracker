# frozen_string_literal: true

module SlashCommand
  module Commands
    class Out < Template
      HELP = "This command will stop the last activity.".freeze
      STOP_SUCCESS_MSG = "You just took a break. Move on! :smiley:".freeze
      ACTIVITY_NOT_RUNNING_MSG = "Hey, what's going on? Let's start an activity first! (e.g: `/tt in <NOTE>`)".freeze

      def self.description
        HELP
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return stop_current_activity if user.running_activity?

        ACTIVITY_NOT_RUNNING_MSG
      end

      def stop_current_activity
        time_entry = user.running_activity
        time_entry.update_attributes(end: Time.current)

        STOP_SUCCESS_MSG
      end
    end
  end
end
