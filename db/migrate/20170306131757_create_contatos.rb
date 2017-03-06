class CreateContatos < ActiveRecord::Migration[5.0]
  def change
    create_table :contatos do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :message

      t.timestamps
    end
  end
end
