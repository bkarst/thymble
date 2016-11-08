require 'bcrypt'
require 'digest/md5'

class ApplicationSetting

  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  field :current_lat, :type => Float
  field :current_long, :type => Float
  field :current_api_domain_index, :type => Integer, :default => 0
  field :current_request_count, :type => Integer, :default => 0
  field :facebook_access_token, :type => String

  def self.setting
    ApplicationSetting.first || ApplicationSetting.create
  end

end
