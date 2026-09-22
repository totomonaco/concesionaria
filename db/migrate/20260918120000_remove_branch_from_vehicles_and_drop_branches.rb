class RemoveBranchFromVehiclesAndDropBranches < ActiveRecord::Migration[8.1]
  def change
    remove_reference :vehicles, :branch, foreign_key: true

    drop_table :branches do |t|
      t.string :name
      t.string :address
      t.timestamps
    end
  end
end
