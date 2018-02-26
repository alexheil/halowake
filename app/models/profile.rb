class Profile < ApplicationRecord
  belongs_to :user

  include ImageUploader[:image]

  validates :facebook_url, presence: true, if: :facebook_handle_present
  validates :facebook_handle, presence: true, if: :facebook_url_present
  validates :twitter_url, presence: true, if: :twitter_handle_present
  validates :twitter_handle, presence: true, if: :twitter_url_present
  validates :instagram_url, presence: true, if: :instagram_handle_present
  validates :instagram_handle, presence: true, if: :instagram_url_present

  private

    def facebook_handle_present
      self.facebook_handle.present?
    end

    def facebook_url_present
      self.facebook_url.present?
    end

    def twitter_handle_present
      self.twitter_handle.present?
    end

    def twitter_url_present
      self.twitter_url.present?
    end

    def instagram_handle_present
      self.instagram_handle.present?
    end

    def instagram_url_present
      self.instagram_url.present?
    end

end
