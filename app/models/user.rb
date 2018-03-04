class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable
   #:omniauthable, :confirmable, :lockable

  attr_accessor :login

  validates :username, presence: true, uniqueness: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z0-9 ]+\Z/i }
  validate :validate_username

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :albums, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :purchases

  has_one :profile, dependent: :destroy
  has_one :theme, dependent: :destroy
  has_one :location, dependent: :destroy
  has_one :payment_setting, dependent: :destroy
  has_one :membership, dependent: :destroy

  before_save :should_generate_new_friendly_id?, if: :username_changed?
  before_save :downcase_username

  before_save :create_customer

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
    Photo.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def voted?(photo)
    Vote.exists? user_id: id, photo_id: photo.id
  end

  def unvote(photo)
    Vote.find_by(user_id: id, photo_id: photo.id).destroy
  end

  def vote_id(photo)
    Vote.find_by(user_id: id, photo_id: photo.id).id
  end

  def is_member
    self.membership.present?
  end

  private

    def create_customer
      if self.customer_id.blank?
        # customer = Stripe::Customer.create({
        #  email: @user.email
        # })

        # self.customer_id = customer.id
      end
    end

    def should_generate_new_friendly_id?
      username_changed?
    end

    def downcase_username
      self.username = username.downcase
    end

end