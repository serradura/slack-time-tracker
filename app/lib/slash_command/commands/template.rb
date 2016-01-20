# frozen_string_literal: true

module SlashCommand
  module Commands
    class Template
      CommandNameError = Class.new(Exception)

      attr_reader :payload, :response

      NAME = nil
      DESC = "Unavailable description."
      HELP = "Unavailable help."

      delegate :user, to: :payload
      delegate :name, :data, to: :@parsed_command

      def initialize(payload, parsed_command)
        @payload = payload
        @response = SlashCommand::Response.new
        @parsed_command = parsed_command
      end

      def self.name!
        const_get(:NAME) || name_error!
      end

      def self.description
        const_get(:DESC)
      end

      def self.help
        const_get(:HELP)
      end

      def self.name_error!
        raise CommandNameError
      end

      def call
        fail NotImplementedError
      end
    end
  end
end
