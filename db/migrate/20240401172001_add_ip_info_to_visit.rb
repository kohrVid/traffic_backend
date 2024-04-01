class AddIpInfoToVisit < ActiveRecord::Migration[7.1]
  def change
    add_reference :visits, :ip_info, foreign_key: true
    remove_column :visits, :ip_address, :string
  end
end
