class AppendBandwithColumnsToSubscribe < ActiveRecord::Migration[7.0]
  def change
    add_column :subscribes, :upload_used, :bigint
    add_column :subscribes, :download_used, :bigint
    add_column :subscribes, :total_bandwidth, :bigint
    add_column :subscribes, :expired_at, :datetime
  end
end
