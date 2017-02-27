class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :description
      t.references :user_client_id, foreign_key: true
      t.references :user_professional_id, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
