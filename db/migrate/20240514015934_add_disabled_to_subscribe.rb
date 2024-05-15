class AddDisabledToSubscribe < ActiveRecord::Migration[7.0]
  def change
    add_column :subscribes, :disabled, :boolean, default: false, null: false
  end
end
