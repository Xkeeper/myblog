module TagHelper
  include ActsAsTaggableOn::TagsHelper

  def linked_tag_list(tags)
    raw tags.collect {|tag| "<li>#{link_to(tag.name, posts_path(:tag => tag.name))}</li>"}.join("")
  end
end
