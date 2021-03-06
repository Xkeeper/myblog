class ArchivesController < ApplicationController
  def index
    @months = Post.find_all_grouped_by_month
    @tags = Post.tag_counts_on(:tags, :order => 'name ASC')
  end
end
