class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :vehicle, null: false, foreign_key: true, index: { unique: true }
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.decimal :price, precision: 14, scale: 2, null: false
      t.string :currency, default: "ars", null: false
      t.string :payment_method, default: "cash", null: false
      t.date :sold_at, null: false
      t.text :notes

      t.timestamps
    end
  end
end
