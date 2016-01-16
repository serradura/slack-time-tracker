module Api
  module V1
    class CommandsController < ApplicationController
      def invoke
        render current_command.response.data
      end

      private

      def current_command
        SlashCommand::Invoke.command_with(params)
      end
    end
  end
end
