class AddUniqeConstraintToIpInfo < ActiveRecord::Migration[7.1]
  def change
    add_index :ip_infos, :address, unique: true
  end
end
