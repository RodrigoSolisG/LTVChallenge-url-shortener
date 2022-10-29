class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  def short_code
    return nil if id == nil
    id = self.id
    short_url = ''
    while id > 0
      short_url += CHARACTERS[id % 62]
      id /= 62
    end
    short_url = short_url.reverse
    update_column(:short_url, short_url)
    short_url
  end

  def update_title!
  end

  def self.find_by_short_code(code)
    ShortUrl.find_by_short_url(code)
  end

  private

  def url_validator?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
    false
  end

  def validate_full_url

    if full_url
      isValid = url_validator?(full_url)
      if !isValid
        errors.add(:errors, "Full url is not a valid url")
        errors.add(:full_url, "is not a valid url")
      end
    else
      errors.add(:full_url, "can't be blank")
    end

    
  end
end
