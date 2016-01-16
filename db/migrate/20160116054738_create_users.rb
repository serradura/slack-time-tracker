class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_id
      t.string :slack_name

      t.timestamps null: false
    end
  end
end
