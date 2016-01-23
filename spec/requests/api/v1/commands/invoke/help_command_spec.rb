require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "help" }
  let(:current_command) { SlashCommand::Commands::Help }
  let(:template_command) { SlashCommand::Commands::Template }

  describe "'help' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    it "responds with all commands help descriptions" do
      expect(response).to have_http_status(200)

      expect(response.body).to_not include template_command.description
      expect(response.body).to be == current_command.help
    end

    context "help" do
      let(:payload_text) { "help help" }

      # TODO: DRY with shared examples.
      it "responds with command instructions" do
        expect(response).to have_http_status(200)

        expect(response.body).to_not include template_command.description
        expect(response.body).to be == current_command.help
      end
    end

    context "unknown help" do
      let(:payload_text) { "help #{Faker::Lorem.word}" }

      it "responds with unknown command message" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == SlashCommand::Commands::Unknown.help
      end
    end
  end
end
