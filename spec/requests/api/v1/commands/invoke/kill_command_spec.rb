require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:current_command) { SlashCommand::Commands::Kill }

  describe "'kill' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "unknown kill command" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "kill #{Faker::Lorem.word}" }
      end

      it "return a unknown message and a command help" do
        expected_message = current_command::INVALID_COMMAND
        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end

    context "correct command" do
      context "activity in progress" do
        let(:current_user) { User.last }
        let(:payload) do
          create(:slack_payload).tap {|pay| pay.text = "in foo bar" }
        end

        before do
          payload.text = "kill current"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "return a success message and delete the last activity" do
          expected_message = current_command::Current::ACTIVITY_DELETED
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity?).to be_falsey
        end
      end

      context "activity not progress" do
        let(:payload) do
          create(:slack_payload).tap {|pay| pay.text = "kill current" }
        end

        it "return with a message that activity is not running " do
          expected_message = current_command::Current::ACTIVITY_NOT_RUNNING
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
        end
      end
    end

    context "help" do
      let(:payload) do
        create(:slack_payload).tap {|pay| pay.text = "help kill" }
      end

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
