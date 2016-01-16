require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'now' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is no running activity" do
      let(:current_user) { User.last }

      let(:payload) do
        create(:slack_now_command_payload)
      end

      it "responds with no current activity message" do
        expected_message = SlashCommand::Commands::Now::NO_CURRENT_ACTIVITY
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.has_activity_running?).to be false
      end
    end

    context "user has a current activity" do
      let(:payload) do
        create(:slack_payload)
      end

      before do
        payload.text = "in test"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "now"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "responds with activity message" do
        expected_message = "test"
        expect(response).to have_http_status(200)
        expect(response.body).to include expected_message
      end
    end

    context "help" do
      let(:payload) do
        create(:slack_now_command_payload).tap {|pay| pay.text = "now help" }
      end

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::Now::HELP

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
