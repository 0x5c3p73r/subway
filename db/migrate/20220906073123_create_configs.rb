class CreateConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :configs, id: :uuid do |t|
      t.string :name, null: false
      t.string :link, null: false
      t.string :source, null: false

      t.timestamps
    end
  end
end
