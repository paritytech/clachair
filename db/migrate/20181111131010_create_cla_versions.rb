class CreateClaVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :cla_versions do |t|
      t.text :license_text
      t.belongs_to :cla, index: true, foreign_key: true

      t.timestamps
    end
  end
end
