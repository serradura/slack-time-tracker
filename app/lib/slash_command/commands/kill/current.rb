# frozen_string_literal: true

module SlashCommand
  module Commands
    class Kill
      class Current
        OPTION = "current"
        ACTIVITY_DELETED = "It's dead. (R.I.P :goberserk:)"
        ACTIVITY_NOT_RUNNING = "There’s no activity to kill. Are you some sort of serial killer?"

        delegate :user, to: :@command

        attr_reader :data

        def initialize(command)
          @command = command
          @data = command.data.downcase
        end

        def invoked?
          data.include?(OPTION)
        end

        def call
          if user.running_activity?
            user.running_activity.delete

            ACTIVITY_DELETED
          else
            ACTIVITY_NOT_RUNNING
          end
        end
      end
    end
  end
end
