require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { should validate_presence_of(:table_id) }

  describe 'validations' do
    let!(:table) { FactoryGirl.create(:table) }
    let(:reservation_params) do
      {
        from_time: (Time.now - 2.hours),
        to_time: (Time.now - 1.hours),
        table_id: table.id
      }
    end

    it 'checks availability' do
      Reservation.create!(reservation_params)

      duplicated_reservation = described_class.new(reservation_params)
      expect(duplicated_reservation.save).to eq(false)
    end
  end
end
