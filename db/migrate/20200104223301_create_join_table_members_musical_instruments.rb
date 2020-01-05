class CreateJoinTableMembersMusicalInstruments < ActiveRecord::Migration[5.2]
  def change
    create_table :member_musical_instruments do |t|
      t.references :member, index: true, foreign_key: true
      t.references :musical_instrument, index: true, foreign_key: true
      t.boolean :primary

      t.timestamps
    end
  end
end
