class Vehicle < ApplicationRecord
  belongs_to :vehicle_model
  has_many :test_drives, class_name: "TestDrive", dependent: :destroy

  validates :year, presence: true, numericality: { greater_than: 1980, less_than_or_equal_to: Date.current.year + 1 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :km, numericality: { greater_than_or_equal_to: 0 }
end
