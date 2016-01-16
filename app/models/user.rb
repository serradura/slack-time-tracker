class User < ActiveRecord::Base
  has_many :time_entries

  validates :slack_name, :slack_id, presence: true
  validates :slack_id, uniqueness: true

  # TODO: Test
  def self.find_or_update_by(params)
    slack_id = params[:user_id]
    slack_name = params[:user_name]

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

  def has_activity_running?
    return time_entries.exists?(end:nil)
  end

  def get_activity_running
    return time_entries.find_by_end(nil)
  end
end
