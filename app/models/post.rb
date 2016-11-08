require 'bcrypt'
require 'digest/md5'
require 'uri'

class Post

  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt  

  belongs_to :user  
  
  has_many :users_upvoted, class_name: "User", inverse_of: nil
  has_many :users_saved, class_name: "User", inverse_of: nil
  has_many :users_hidden, class_name: "User", inverse_of: nil
  has_many :comments

  field :url, :type => String
  field :text, :type => String
  field :domain, :type => String
  field :url_title, :type => String
  field :title, :type => String
  field :front_page_score, :type => Float
  field :points, :type => Integer, :default => 1
  field :comment_count, :type => Integer, :default => 0
  field :flagged_count, :type => Integer, :default => 0
  field :favorite_count, :type => Integer, :default => 0
  field :active, :type => Boolean, :default => true
  field :edited, :type => Boolean
  field :flagged_for_removal, :type => Boolean
  
  validates_presence_of :title, message: "title is a required field"
  validates_uniqueness_of :title, message: "title has already been used"  
  validates_format_of :title, with: /\A[\sa-z0-9\-_]+\z/i, message: "Story title can only contain letters, digits, dashes and underscores. Please choose another."
  validates_length_of :title, minimum: 2, maximum: 150, message: "Title can be a minimum of 2 and maximum of 150 characters."
  index({ url_title: 1 }, { unique: true, name: "url_title_index" })
  index({ comment_count: 1 })
  index({ created_at: 1 })
  index({ domain: 1 })
  index({ active: 1 })

  before_save do |document|
    string = title.downcase.gsub(/ /, '-')
    self.url_title = CGI.escape(string)
    if url.present?
      self.domain = get_domain
    end
  end

  def front_page_score
    self.points/(Time.now - self.created_at)/15
  end

  def order_comments_by(order_by_string='oldest')
    if order_by_string == 'newest'
      self.comments.where(:parent_comment_id => nil).order_by('created_at desc')
    elsif order_by_string == 'oldest'
      self.comments.where(:parent_comment_id => nil).order_by('created_at asc')
    else
      self.comments.where(:parent_comment_id => nil).order_by('points desc, created_at desc')
    end  
  end


  def upvoted(upvoted_by)
    upvoted_by.upvoted_posts[self.id.to_s] = Time.now
    self.points = self.points + 1      
    post_owner = self.user
    post_owner.karma = post_owner.karma + 1
    post_owner.post_karma = post_owner.post_karma + 1
    post_owner.save
    self.save
    upvoted_by.save
  end

  def unvoted(unvoted_by)
    unvoted_by.upvoted_posts.delete(self.id.to_s)
    unvoted_by.save
    self.points = self.points - 1
    post_owner = self.user
    post_owner.karma = post_owner.karma - 1
    post_owner.post_karma = post_owner.post_karma - 1
    post_owner.save
    self.save
  end

  
  def link
    if url.present?
      return url
    else
      "/post/#{self.url_title}"
    end
  end

  def has_url_and_text_valid?
    # return false unless url_valid?    
    if (url.present? && text.present?) || (url.blank? && text.blank?)
      return false
    end    
    return true
  end

  def url_valid?
    if url.present? && Post.where(url: url).first.present?
      return false
    end
    begin
      uri = URI.parse(url)
      uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      return false
    end
    true
  end

  def get_domain
    uri = URI.parse(url)
    uri = URI.parse("http://#{url}") if uri.scheme.nil?
    host = uri.host.downcase
    host_string = host.start_with?('www.') ? host[4..-1] : host
    host_string.split('.').last(2).join('.')
  end


end
