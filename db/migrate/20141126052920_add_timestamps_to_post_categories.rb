class AddTimestampsToPostCategories < ActiveRecord::Migration
  def change
    add_column :post_categories, :created_at, :timestamp
    add_column :post_categories, :updated_at, :timestamp
  end
end
