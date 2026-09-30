class CreateAppraisals < ActiveRecord::Migration[8.0]
  def change
    create_table :appraisals do |t|
      t.references :user, null: true, foreign_key: true
      t.string  :make,       null: false
      t.string  :car_model,  null: false
      t.integer :year,        null: false
      t.integer :km,          null: false
      t.text    :description
      t.decimal :quoted_price, precision: 12, scale: 2
      t.string  :status,      default: "pending", null: false
      t.text    :admin_notes

      t.timestamps
    end
  end
end
