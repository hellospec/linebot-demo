class Product < ApplicationRecord
  has_many :sales

  after_validation :generate_slug, only: [:create, :update]

  validates :code, presence: true
  validates :code, uniqueness: { case_sensitive: false }

  def to_param
    if persisted?
      [id, slug].join("-")
    end
  end

  private

  def generate_slug
    if name.size.positive? && name.parameterize.blank?
      # For non-english
      value = name.strip.gsub(/\s+/,"-")
    else
      value = name.parameterize
    end

    self.slug = value
  end
end
