class RenameModelNameToCarModelInAppraisals < ActiveRecord::Migration[8.0]
  def up
    rename_column :appraisals, :model_name, :car_model if column_exists?(:appraisals, :model_name)
  end

  def down
    rename_column :appraisals, :car_model, :model_name if column_exists?(:appraisals, :car_model)
  end
end
