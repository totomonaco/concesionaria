class CreateTestDrives < ActiveRecord::Migration[8.1]
  def change
    create_table :test_drives do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :scheduled_date
      t.time :scheduled_time
      t.integer :status

      t.timestamps
    end
  end
end
