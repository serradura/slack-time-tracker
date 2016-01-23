require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "display" }

  describe "'display' command" do
    let(:current_user) { User.last }

    before do
      User.delete_all
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there are no activities registered" do
      it "responds with no activities message" do
        expected_message = SlashCommand::Commands::Display::NO_HISTORY_ACTIVITY
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.running_activity?).to be_falsey
      end
    end

    context "user has registered activities to display" do
      before do
        payload.text = "in test 1"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "out"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "in test 2"
        post api_v1_commands_invoke_path, payload.to_h

        payload.text = "display"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "responds list of activities information" do
        expect(response).to have_http_status(200)
      end

      context "with --ids option"do
        xit "responds list of activities information"
      end
    end

    context "help" do
      let(:payload_text) { "help display" }

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::Display.help

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
