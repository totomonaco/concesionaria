class Vehicle < ApplicationRecord
  belongs_to :vehicle_model
  belongs_to :branch
  has_many :test_drives, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :year, presence: true, numericality: { greater_than: 1980, less_than_or_equal_to: Date.current.year + 1 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :km, numericality: { greater_than_or_equal_to: 0 }
end
