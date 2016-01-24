require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  let(:payload) { create(:slack_payload).tap {|pay| pay.text = payload_text } }
  let(:payload_text) { "kill" }
  let(:current_user) { User.last }
  let(:current_command) { SlashCommand::Commands::Kill }

  describe "'kill' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "unknown kill command option" do
      let(:payload_text) { "kill #{Faker::Lorem.word}" }

      it "return a unknown message and a command help" do
        expected_message = current_command::INVALID_COMMAND

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end

    context "'current' option" do
      context "when there is an activity in progress" do
        let(:payload_text) { "in foo bar" }

        before do
          payload.text = "kill current"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "return a success message and delete the current activity" do
          expected_message = current_command::Handler::ACTIVITY_DELETED
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity?).to be_falsey
        end
      end

      context "when there is no activities in progress" do
        let(:payload_text) { "kill current" }

        it "returns with a message that activity is not running " do
          expected_message = current_command::Handler::ACTIVITY_NOT_RUNNING
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
        end
      end
    end

    context "'last' option" do
      context "when there is an activity in progress" do
        let(:payload_text) { "in foo bar" }

        before do
          payload.text = "kill last"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "return a success message and delete the current activity" do
          expected_message = current_command::Handler::ACTIVITY_DELETED
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity?).to be_falsey
        end
      end

      context "when there is no activities in progress" do
        context "and the user hasn't activities" do
          let(:payload_text) { "kill last" }

          it "returns with a message that activity is not running " do
            expected_message = current_command::Handler::ACTIVITY_NOT_RUNNING
            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message
          end
        end

        context "and the user has activities" do
          let(:payload_text) { "in bar ber bir" }

          before do
            payload.text = "out"
            post api_v1_commands_invoke_path, payload.to_h

            payload.text = "kill last"
            post api_v1_commands_invoke_path, payload.to_h
          end

          it "return a success message and delete the last activity" do
            expected_message = current_command::Handler::ACTIVITY_DELETED
            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message
            expect(current_user.time_entries).to be_blank
          end
        end
      end
    end

    context "'--id' option" do
      context "when the active belongs to another user" do
        let(:user_a) { User.find_by slack_id: user_a_payload.user_id }
        let(:user_a_payload) { create(:slack_payload) }
        let(:user_b_payload) { create(:slack_payload) }

        before do
          user_a_payload.text = "in foo"
          post api_v1_commands_invoke_path, user_a_payload.to_h

          post api_v1_commands_invoke_path, user_b_payload.to_h

          user_b_payload.text = "kill -i #{user_a.running_activity.id}"
          post api_v1_commands_invoke_path, user_b_payload.to_h
        end

        it "returns with a message that activity is not running " do
          expected_message = current_command::Handler::ACTIVITY_NOT_RUNNING
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
        end
      end

      context "when there is an activity in progress" do
        let(:last_time_entry) { current_user.time_entries.last }
        let(:payload_text) { "in foo bar" }

        before do
          payload.text = "kill --id #{last_time_entry.id}"
          post api_v1_commands_invoke_path, payload.to_h
        end

        it "return a success message and delete the activity" do
          expected_message = current_command::Handler::ACTIVITY_DELETED
          expect(response).to have_http_status(200)
          expect(response.body).to be == expected_message
          expect(current_user.running_activity).to be_blank
        end
      end

      context "when there is no activities in progress" do
        context "and the user hasn't activities" do
          let(:payload_text) { "kill last" }

          it "returns with a message that activity is not running " do
            expected_message = current_command::Handler::ACTIVITY_NOT_RUNNING
            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message
          end
        end

        context "and the user has activities" do
          let(:payload_text) { "in bar ber bir" }

          before do
            payload.text = "out"
            post api_v1_commands_invoke_path, payload.to_h

            payload.text = "kill last"
            post api_v1_commands_invoke_path, payload.to_h
          end

          it "return a success message and delete the activity" do
            expected_message = current_command::Handler::ACTIVITY_DELETED
            expect(response).to have_http_status(200)
            expect(response.body).to be == expected_message
            expect(current_user.time_entries).to be_blank
          end
        end
      end
    end

    context "help" do
      let(:payload_text) { "help kill" }

      it "responds with command instructions" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == current_command.help
      end
    end
  end
end
