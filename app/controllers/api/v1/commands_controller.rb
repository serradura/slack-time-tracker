module Api
  module V1
    class CommandsController < ApplicationController
      InvalidTokenError = Class.new(Exception)

      def invoke
        fail(InvalidTokenError) unless params[:token] == Rails.application.secrets.fetch(:slack_token)

        @user = params.fetch(:user_name)
        @text = params.fetch(:text).tap(&:strip!)

        content = case @text
                  when /when/ then when_content
                  when /what/ then what_content
                  else "Unknown command :cry:"
                  end

        render text: content
      end

      rescue_from InvalidTokenError do |_exception|
        render text: "Unknown slack token :astonished:", status: 500
      end

      private

      def when_content
        <<-BODY.strip_heredoc
          The next Hey! event will be held on the 20th May from 7:30pm at The Belgrave in central Leeds.

          Hopefully see you then #{@user}!

          http://hey.wearestac.com/
        BODY
      end

      def what_content
        <<-BODY.strip_heredoc.freeze
          The next Hey! event has two lectures planned. The first one is with Rich Fiddaman discussing everything hospitality. The second is with Matt Dix discussing Leeds Indie Food Festival.

          http://hey.wearestac.com/lectures/a-pint-with-the-pub-landlord

          http://hey.wearestac.com/lectures/kickstarting-a-city-wide-food-festival
        BODY
      end
    end
  end
end
