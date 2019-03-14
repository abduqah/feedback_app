class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states do |t|
      t.string :device
      t.string :os
      t.integer :memory
			t.integer :storage

      t.timestamps
		end
		add_reference :states, :feedback, foreign_key: true, index: true, null: false
  end
end
