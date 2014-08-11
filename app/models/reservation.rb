class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table_id, presence: true
end
