class Photo < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include ImageUploader[:image]

  default_scope -> { order('id DESC') }

  belongs_to :album
  belongs_to :user

  has_many :votes, dependent: :destroy
  has_many :purchases

  validates :currency, presence: true, if: :is_for_sale
  validates :base_price, presence: true, length: { maximum: 6 }, numericality: { greater_than: 0}, if: :is_for_sale
  validates :shipping_price, presence: true, length: { maximum: 6 }, numericality: { greater_than: -1}, if: :is_for_sale
  validates :quantity, presence: true, if: :is_for_sale
  #validates :total_price, presence: true, if: :is_for_sale
  
  before_save :downloadable_or_shippable_check
  before_save :art_or_photo_check
  before_save :reset_photo_options
  before_save :reset_art_options
  before_save :reset_sales_options
  before_save :total_price_calculator
  before_save :should_generate_new_friendly_id?, if: :title_changed?

  def photo_resolution
   # get photo resolution from metadata
  end

  private

    def is_for_sale
      self.for_sale == true
    end

    def reset_sales_options
      if self.for_sale == false
        self.base_price = nil
        self.shipping_price = nil
        self.currency = nil
        self.quantity = nil
        self.total_price = nil
      end
    end

    def art_or_photo_check
      if self.is_photo? && self.is_art?
        self.is_photo = 1
        self.is_art = 0
      elsif self.is_photo == false && self.is_art == false
        self.is_photo = 1
        self.is_art = 0
      end
    end

    def downloadable_or_shippable_check
      if self.downloadable? && self.shippable?
        self.shippable = 1
        self.downloadable = 0
      elsif self.downloadable == false && self.shippable == false
        self.shippable = 1
        self.downloadable = 0
      end
    end

    def reset_photo_options
      if self.is_art?
        self.resolution = nil
        self.camera = nil
        self.lens = nil
        self.aperture = nil
        self.exposure = nil
        self.flash = nil
        self.focal_length = nil
        self.iso = nil
      end
    end

    def reset_art_options
      if self.is_photo?
        self.tool = nil
        self.medium = nil
        self.surface = nil
        self.size = nil
        self.style = nil
      end
    end

    def total_price_calculator
      self.total_price = base_price + shipping_price if self.for_sale == true
    end

    def should_generate_new_friendly_id?
      title_changed?
    end

end
