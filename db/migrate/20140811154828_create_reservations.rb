class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :table, index: true
      t.timestamp :from_time
      t.timestamp :to_time

      t.timestamps
    end
  end
end
