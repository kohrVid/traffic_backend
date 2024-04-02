class AddRegistrationIpInfoToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :registration_ip_info, foreign_key: { to_table: :ip_infos }
    remove_column :users, :registration_ip_address, :string
  end
end
