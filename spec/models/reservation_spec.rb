require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"

  describe 'validations' do
    it 'checks availability' do
      Reservation.create!(from_time: (Time.now - 2.hours), to_time: (Time.now - 1.hours))

      reservation = described_class.new(from_time: (Time.now - 2.hours), to_time: (Time.now - 1.hours))
      expect(reservation.save).to eq(false)
    end
  end
end
