class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  def short_code
  end

  def update_title!
  end

  private

  def url_validator?(url)
    uri = URL.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
    false
  end

  def validate_full_url
    isValid = url_validator(full_url)
    if !isValid
      errors.add(:full_url, "isn't a valid URL")
    end
  end

end
