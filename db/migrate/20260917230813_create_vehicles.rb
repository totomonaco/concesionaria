class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.references :vehicle_model, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.integer :year
      t.decimal :price
      t.integer :km
      t.boolean :used
      t.text :description

      t.timestamps
    end
  end
end
