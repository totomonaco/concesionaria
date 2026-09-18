class VehicleModel < ApplicationRecord
  belongs_to :brand
  has_many :vehicles, dependent: :destroy
  validates :name, presence: true
end
