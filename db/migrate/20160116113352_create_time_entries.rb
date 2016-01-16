class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.references :user, index: true, foreign_key: true
      t.date :date
      t.datetime :start
      t.datetime :end
      t.integer :duration
      t.text :note

      t.timestamps null: false
    end
  end
end
