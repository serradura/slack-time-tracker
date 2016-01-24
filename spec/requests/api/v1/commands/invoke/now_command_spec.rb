require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "now" }
  let(:current_command) { SlashCommand::Commands::Now }

  describe "'now' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is no running activity" do
      let(:current_user) { User.last }

      it "responds with no current activity message" do
        expected_message = current_command::NO_CURRENT_ACTIVITY

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.running_activity).to be_blank
      end
    end

    context "user has a current activity" do
      before do
        payload.text = "in test"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "now"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "responds with activity message" do
        expect(response).to have_http_status(200)
        expect(response.body).to match match(/(\d{2}:){2}\d{2}/)
      end
    end

    context "help" do
      let(:payload_text) { "help now" }

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
