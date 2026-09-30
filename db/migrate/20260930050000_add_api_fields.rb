class AddApiFields < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :api_token, :string
    add_index :users, :api_token, unique: true

    add_column :vehicles, :condition, :string, default: "used", null: false
  end
end
