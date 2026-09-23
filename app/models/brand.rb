class Brand < ApplicationRecord
  has_many :vehicle_models, dependent: :destroy
  validates :name, presence: { message: "no puede estar en blanco" }, uniqueness: { message: "ya existe" }
end
