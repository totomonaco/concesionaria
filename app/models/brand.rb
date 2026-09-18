class Brand < ApplicationRecord
    has_many :vehicle_models, dependent: :destroy
    validates :name, presence: true, uniqueness: true
end
