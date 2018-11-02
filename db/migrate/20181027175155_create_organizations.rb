class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :uid
      t.string :login
      t.string :name
      t.string :github_url

      t.timestamps
    end

    add_index(:organizations, [:uid, :login], unique: true)
  end
end
