class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.belongs_to :organization, index: true
      t.string :uid
      t.string :name
      t.string :github_url
      t.string :desc
      t.string :license_name
      t.string :spdx_id

      t.timestamps
    end

    add_index(:repositories, [:organization_id, :uid, :spdx_id], unique: true)
  end
end
