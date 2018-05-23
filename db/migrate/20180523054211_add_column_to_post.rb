class AddColumnToPost < ActiveRecord::Migration[5.2]
  def change
    add_reference :post, :user, index: true
  end
end
