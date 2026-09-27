class AddStatusToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :status, :integer, default: 0, null: false
    add_index :vehicles, :status
  end
end
