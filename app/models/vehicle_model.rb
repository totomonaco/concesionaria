class VehicleModel < ApplicationRecord
  belongs_to :brand
  has_many :vehicles, dependent: :destroy
  validates :name, presence: { message: "no puede estar en blanco" }
  validates :brand, presence: { message: "debe seleccionarse" }
end
