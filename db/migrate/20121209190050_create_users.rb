class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :assembla_id
      t.string :login
      t.string :name
      t.string :email
      t.string :organization
      t.string :string
      t.string :phone
      t.string :picture

      t.timestamps
    end
  end
end
