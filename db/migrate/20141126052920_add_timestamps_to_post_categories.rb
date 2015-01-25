class AddTimestampsToPostCategories < ActiveRecord::Migration
  def change
    add_column :post_categories, :created_at, :timestamps
    add_column :post_categories, :updated_at, :timestamps
  end
end
