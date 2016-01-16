class User < ActiveRecord::Base
  validates :slack_name, :slack_id, presence: true
  validates :slack_id, uniqueness: true

  # TODO: Test
  def self.find_or_update_by(params)
    slack_id, slack_name = params[:user_id], params[:user_name]

    User
      .create_with(slack_name: slack_name)
      .find_or_create_by(slack_id: slack_id)
      .tap do |account|
        account.update_attribute(:slack_name, slack_name) if account.name != slack_name
      end
  end

  def name
    slack_name
  end
end
