url = if @tag.nil?
  formatted_posts_path(:format => 'atom', :only_path => false)
else
  posts_path(:tag => @tag, :format => 'atom', :only_path => false)
end

atom_feed(
  :url         => url,
  :root_url    => posts_path(:tag => @tag, :only_path => false),
  :schema_date => '2012'
) do |feed|
  feed.title     posts_title(@tag)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:edited_at).max
  feed.generator "Xkeeper memopad", "uri" => "http://blog.0fh.ru"

  feed.author do |xml|
    xml.name  author.name
    xml.email author.email unless author.email.nil?
  end

  @posts.each do |post|
   feed.entry(post, :url => post_path(post, :only_path => false), :published => post.published_at, :updated => post.edited_at) do |entry|
      entry.title   post.title
      entry.content post.body_html, :type => 'html'
    end
  end
end
