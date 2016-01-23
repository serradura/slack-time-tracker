# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Handler
        ACTIVITY_DELETED = "It's dead. (R.I.P :goberserk:)"
        ACTIVITY_NOT_RUNNING = "There’s no activity to kill. Are you some sort of serial killer?"

        attr_reader :message, :user

        def initialize(command)
          @user = command.user
          @data = command.data.downcase
          @deleted = false
          @message = ACTIVITY_NOT_RUNNING
        end

        def invoke?(option)
          @data.include?(option)
        end

        def delete_when(truth)
          return if !truth || @deleted

          yield
          @deleted = true
          @message = ACTIVITY_DELETED
        end
      end
    end
  end
end
