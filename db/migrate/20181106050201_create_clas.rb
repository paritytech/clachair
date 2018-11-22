class CreateClas < ActiveRecord::Migration[5.2]
  def change
    create_table :clas do |t|
      t.string :name

      t.timestamps
    end

    add_reference :repositories, :cla, index: true, foreign_key: true
  end
end
