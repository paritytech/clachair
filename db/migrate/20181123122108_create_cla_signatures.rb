class CreateClaSignatures < ActiveRecord::Migration[5.2]
  def change
    create_table :cla_signatures do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :cla_version, index: true, foreign_key: true
      t.belongs_to :repository, index: true, foreign_key: true

      t.string :real_name, null: false

      t.timestamps
    end
  end
end
