# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email,   null: false, default: ""
      t.string :provider
      t.string :uid
      t.string :login
      t.string :name

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
  end
end
