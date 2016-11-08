require 'bcrypt'
require 'digest/md5'

class User

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include BCrypt


  has_many :comments
  has_many :posts  

  #has_many links, comments, 

  field :username, :type => String
  field :email, :type => String
  field :about, :type => String
  field :password_digest, :type => String
  field :reset_password_token, :type => String
  field :karma, :type => Integer, :default => 1
  field :post_karma, :type => Integer, :default => 1
  field :comment_karma, :type => Integer, :default => 1
  field :upvoted_posts, type: Hash, default: {}
  field :upvoted_comments, type: Hash, default: {}
  field :admin, type: Boolean, default: false
  field :saved_posts, type: Hash, default: {}
  field :flagged_posts, type: Hash, default: {}
  
  validates_presence_of :username, message: "username is a required field"
  # validates_presence_of :password, message: "password is a required field"
  validates_uniqueness_of :username, message: "username has already been taken. please choose a different one.", :allow_nil => false
  validates_format_of :username, with: /\A[a-z0-9\-_]+\z/i, message: "Usernames can only contain letters, digits, dashes and underscores, and should be between 2 and 15 characters long. Please choose another."
  # validates_length_of :password, minimum: 4, maximum: 16, message: "Passwords must be 4 and 16 letters long. Please choose another"
  validates_length_of :username, minimum: 2, maximum: 15, message: "Usernames can only contain letters, digits, dashes and underscores, and should be between 2 and 15 characters long. Please choose another."
  has_secure_password
  
  index({ email: 1 })

  def email_valid?
    if email.present? && User.where(email: email).first.present?
      return false
    end
    return true
  end

  def username_valid?
    asdf = /\A[a-z0-9\-_]+\z/i
    
  end

end
