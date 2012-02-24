class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  acts_as_taggable

  has_many                :comments, :dependent => :destroy
  has_many                :approved_comments, :class_name => 'Comment'

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_header, :apply_filter

  validates_presence_of   :title, :slug, :body

  validate                :validate_published_at_natural

  self.per_page = 10

  def validate_published_at_natural
    errors.add("published_at_natural", "Unable to parse time") unless published?
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end

  def published?
    published_at?
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, 'now', "%Y-%m-%d %H:%M:%S")
  end

  class << self
    def build_for_preview(params)
      post = Post.new(params)
      post.generate_slug
      post.set_dates
      post.apply_header
      post.apply_filter
      TagList.from(params[:tag_list]).each do |tag|
        post.tags << Tag.new(:name => tag)
      end
      post
    end

    def find_recent(options = {},page)
      tag = options.delete(:tag)
      options = {
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.zone.now],
      }.merge(options)
      if tag
        find_tagged_with(tag, options)
      else
        Post.paginate(:page => page).find(:all, options)
      end
    end

    def find_by_permalink(year, month, day, slug, options = {})
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        post = find_all_by_slug(slug, options).detect do |post|
          [:year, :month, :day].all? {|time|
            post.published_at.send(time) == day.send(time)
          }
        end
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end

    def find_all_grouped_by_month
      posts = find(
        :all,
        :order      => 'posts.published_at DESC',
        :conditions => ['published_at < ?', Time.now]
      )
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
  end

  def destroy_with_undo
    transaction do
      item = DeletePostUndo.create_undo(self)
      self.destroy
      return item
    end
  end

  def month
    published_at.beginning_of_month
  end

  def apply_header
    header_length = 250
    if self.body.length < header_length + 50;
      self.body_header = self.body
    else
    index = self.body.index('<blogcut>')
    wordcount = index ? index : header_length
    charcount = self.body.rindex(/[\r\n]/, wordcount)
    self.body_header = self.body[0...charcount]
    end
    #self.body = self.body[charcount..-1]
  end

  def apply_filter
    self.body_html = EnkiFormatter.format_as_xhtml(self.body)
    self.body_html.sub!(/<blogcut>.?<br \/>|<blogcut>/, "<a id='blogcut'></a>")
    self.body_header_html = EnkiFormatter.format_as_xhtml(self.body_header)
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    self.published_at = Chronic.parse(self.published_at_natural)
    print "natural  #{self.published_at_natural}"
    print "publat #{self.published_at}"
  end

  def denormalize_comments_count!
    Post.update_all(["approved_comments_count = ?", self.approved_comments.count], ["id = ?", self.id])
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end

  # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
  def tag_list=(value)
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end
end
