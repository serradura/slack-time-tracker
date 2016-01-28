module Api
  module V1
    class CommandsController < ApplicationController
      def invoke
        Chronic.time_class = Time.zone

        render command_response.data
      end

      private

      def command_response
        SlashCommand::Invoke.command_with(params)
      end
    end
  end
end
