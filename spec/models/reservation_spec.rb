require 'rails_helper'

RSpec.describe Reservation, :type => :model do

  it { should validate_presence_of(:table_id) }

  describe 'validations' do
    let!(:table) { FactoryGirl.create(:table) }
    let(:reservation_params) do
      {
        from_time: (Time.now - 2.hours),
        to_time: (Time.now + 2.hours),
        table_id: table.id
      }
    end
    let!(:reservation) { Reservation.create!(reservation_params) }

    context 'when table is reservated already in given period of time' do
      # invalid periods:
      # A a1 b1 B #1
      # a1 A b1 B #2
      # A a1 B b1 #3
      # a1 A B b1 #4
      it "doesn't allow to create reservation" do
        duplicated_reservation = described_class.new(reservation_params)
        expect(duplicated_reservation.save).to eq(false)

        duplicated_reservation1 = described_class.new({
          table_id: table.id,
          from_time: (Time.now - 1.hours),
          to_time: (Time.now + 1.hours)
        })
        expect(duplicated_reservation1.save).to eq(false)

        duplicated_reservation2 = described_class.new({
          table_id: table.id,
          from_time: (Time.now - 3.hours),
          to_time: (Time.now + 1.hours)
        })
        expect(duplicated_reservation2.save).to eq(false)

        duplicated_reservation3 = described_class.new({
          table_id: table.id,
          from_time: (Time.now - 1.hours),
          to_time: (Time.now + 3.hours)
        })
        expect(duplicated_reservation3.save).to eq(false)

        duplicated_reservation4 = described_class.new({
          table_id: table.id,
          from_time: (Time.now - 3.hours),
          to_time: (Time.now + 3.hours)
        })
        expect(duplicated_reservation4.save).to eq(false)
      end
    end

    context 'when table is not reservated in given period of time' do
      # correct periods:
      # a1 b1 A B #1
      # A B a1 b1 #2
      it 'allows to create reservation' do
        correct_reservation = described_class.new({
          table_id: table.id,
          from_time: (Time.now - 4.hours),
          to_time: (Time.now - 3.hours)
        })
        expect(correct_reservation.save).to eq(true)

        correct_reservation2 = described_class.new({
          table_id: table.id,
          from_time: (Time.now + 3.hours),
          to_time: (Time.now + 4.hours)
        })
        expect(correct_reservation2.save).to eq(true)
      end
    end
  end
end
