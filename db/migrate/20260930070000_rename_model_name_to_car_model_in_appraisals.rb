class RenameModelNameToCarModelInAppraisals < ActiveRecord::Migration[8.0]
  def change
    rename_column :appraisals, :model_name, :car_model
  end
end
