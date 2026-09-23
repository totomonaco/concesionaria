class AddCurrencyToVehicles < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :currency, :string, default: "ars", null: false
  end
end
