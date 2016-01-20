require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:current_command) { SlashCommand::Commands::In }

  describe "'in' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "there is a running activity" do
      let(:current_user) { User.last }

      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "in test" }
      end

      before do
        payload.text = "in note"
        post api_v1_commands_invoke_path, payload.to_h
      end

      it "stop last activity and start a new one" do
        expected_message = current_command::STOPED_LAST_CREATED_NEW

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.time_entries.where(end: nil).count).to be == 1
      end
    end

    context "there is no running activity" do
      let(:current_user) { User.last }

      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "in foo" }
      end

      it "responds with a new activity entry message" do
        expected_message = current_command::NEW_ACTIVITY_CREATED

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
        expect(current_user.time_entries.count).to_not be_zero
      end
    end

    context "there is no note" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "in#{[' ', "\n", "\t"].sample * rand(20)}" }
      end

      it "responds with not allowed empty note activity" do
        expected_message = current_command::EMPTY_NOTE_MSG

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end

    context "help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help in" }
      end

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
