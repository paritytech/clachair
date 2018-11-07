class CreateClas < ActiveRecord::Migration[5.2]
  def change
    create_table :clas do |t|
      t.string :name

      t.timestamps
    end

    add_reference :repositories, :cla, index: true
    add_foreign_key :repositories, :clas
  end
end
