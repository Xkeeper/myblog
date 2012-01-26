class AddHeaderToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :body_header, :text
    add_column :posts, :body_header_html, :text
  end
end
