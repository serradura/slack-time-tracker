# frozen_string_literal: true

module SlashCommand
  module Commands
    class Out < Template
      NAME = "out"
      DESC = "This command will stop the last activity."

      HELP = "This command will stop the last activity."

      STOP_SUCCESS_MSG = "You just took a break. Move on!"
      ACTIVITY_NOT_RUNNING_MSG = "There’s no project to leave. Where do you think you are going?"

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
