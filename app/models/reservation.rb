class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table_id, presence: true
  validates :from_time, presence: true
  validates :to_time, presence: true
  validate :check_availability
  validate :validate_time_period

  private

  def check_availability
    scope = Reservation.joins(:table).where(table_id: self.table_id)
    scope = scope.where(time_availability_query, {from_time: self.from_time, to_time: self.to_time})

    if scope.count > 0
      errors.add(:availability, "please select other time period, current is already reserved")
    end
  end

  def validate_time_period
    if self.from_time >= self.to_time
      errors.add(:from_time, 'from time should be earlier than to time')
    end
  end

  def time_availability_query
    "NOT (
      (:from_time <= reservations.from_time AND :from_time <= reservations.to_time AND
      :to_time <= reservations.from_time AND :to_time <= reservations.to_time)
      OR
      (reservations.from_time <= :from_time AND reservations.to_time <= :from_time AND
      reservations.from_time <= :to_time AND reservations.to_time <= :to_time)
    )"
  end
end
