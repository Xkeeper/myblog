class ArchivesController < ApplicationController
  def index
    @months = Post.find_all_grouped_by_month
    @tags = Post.tag_counts_on(:tags)
  end
  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
  end
end
