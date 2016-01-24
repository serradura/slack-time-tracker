# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Handler
        ACTIVITY_DELETED = "It's dead. (R.I.P :goberserk:)"
        ACTIVITY_NOT_RUNNING = "There’s no activity to kill. Are you some sort of serial killer?"

        attr_reader :message, :user, :matches

        def initialize(command)
          @user = command.user
          @data = command.data.downcase
          @executed = false
          @message = ACTIVITY_NOT_RUNNING
        end

        def invoke?(option)
          @matches = @data.match(option)
        end

        def delete(time_entry)
          return if @executed || time_entry.blank?
          time_entry.delete

          @executed = true
          @message = ACTIVITY_DELETED
        end
      end
    end
  end
end
