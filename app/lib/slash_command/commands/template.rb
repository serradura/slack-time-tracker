# frozen_string_literal: true

module SlashCommand
  module Commands
    class Template
      attr_reader :payload, :response

      DESC = "Unavailable description."

      delegate :user, to: :payload
      delegate :name, :data, :help?, to: :@parsed_command

      def initialize(payload, parsed_command)
        @payload = payload
        @response = SlashCommand::Response.new
        @parsed_command = parsed_command
      end

      def self.description
        const_get(:DESC)
      end

      def call
        fail NotImplementedError
      end
    end
  end
end
