require 'bcrypt'
require 'digest/md5'

class Comment

  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  belongs_to :user  
  belongs_to :post
  # has_many :replies, class_name: "Comment", inverse_of: nil
  
  field :replies, type: Array, default: []
  field :users_upvoted, type: Array, default: []
  field :comment_text, :type => String
  field :upvotes, :type => Integer, :default => 1
  field :parent_comment_id, :type => String
  field :nesting, :type => Integer, :default => 0
  field :points, :type => Integer, :default => 1
  field :edited, :type => Boolean
  field :active, :type => Boolean, :default => true
  # field :flagged_count, :type => Integer, :default => 0

  
  validates_presence_of :comment_text, message: "text is a required field"
  validates_presence_of :user

  def replies_obj
    Comment.find(replies).delete_if{|x| x.active == false }
  end

  def upvoted(upvoted_by)
    upvoted_by.upvoted_comments[self.id.to_s] = Time.now  
    self.upvotes = self.upvotes + 1
    self.points = self.points + 1
    comment_owner = self.user
    comment_owner.karma = comment_owner.karma + 1
    comment_owner.comment_karma = comment_owner.comment_karma + 1
    comment_owner.save
    upvoted_by.save
    self.save
  end

  def unvoted(downvoted_by)
    downvoted_by.upvoted_comments.delete(self.id.to_s)
    self.upvotes = self.upvotes - 1
    self.points = self.points - 1
    comment_owner = self.user
    comment_owner.karma = comment_owner.karma - 1
    comment_owner.comment_karma = comment_owner.comment_karma - 1
    comment_owner.save
    downvoted_by.save
    self.save    
  end

  
end
