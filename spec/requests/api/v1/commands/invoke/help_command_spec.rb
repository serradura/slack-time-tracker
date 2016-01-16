require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'help' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) { create(:slack_help_command_payload) }

    it "responds with all commands help descriptions" do
      expect(response).to have_http_status(200)

      expect(response.body).to_not include SlashCommand::Commands::Template.description

      SlashCommand::Invoke::COMMANDS.each do |name, command|
        expect(response.body).to include name
        expect(response.body).to include command.description
      end
    end

    context "help" do
      let(:payload) do
        create(:slack_help_command_payload).tap {|pay| pay.text = "help help" }
      end

      # TODO: DRY with shared examples.
      it "responds with command instructions" do
        expect(response).to have_http_status(200)

        expect(response.body).to_not include SlashCommand::Commands::Template.description

        SlashCommand::Invoke::COMMANDS.each do |name, command|
          expect(response.body).to include name
          expect(response.body).to include command.description
        end
      end
    end
  end
end
