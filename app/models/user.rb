class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10**6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio

    user_phone = "+1" + "#{self.phone}"
    msg = "Hi, please input the pin to continue login: #{self.pin}"
    # set up a client to talk to the Twilio REST API
    client = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]
    client.account.messages.create({ :from => ENV["TWILIO_PHONE_NUMBER"], :to => phone, :body => msg })
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end
end
