# frozen_string_literal: true

module SlashCommand
  module Commands
    class Out < Template
      HELP = "This command will stop the last activity.".freeze
      STOP_SUCCESS_MSG = "You just took a break. Move on!".freeze
      ACTIVITY_NOT_RUNNING_MSG = "There’s no project to leave. Where do you think you are going?".freeze

      def self.description
        HELP
      end

      def call
        response.result = result
      end

      private

      def result
        return HELP if help?
        return STOP_SUCCESS_MSG if user.stop_running_activity

        ACTIVITY_NOT_RUNNING_MSG
      end
    end
  end
end
