class Stats
  def post_count
    Post.count
  end

=begin
  def comment_count
    Comment.count
  end
=end

  def tag_count
    ActsAsTaggableOn::Tag.count
  end
end
