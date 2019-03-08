class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.string :company_token
      t.integer :number
      t.integer :priority

      t.timestamps
    end
  end
end
