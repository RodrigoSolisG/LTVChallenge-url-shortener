class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validate :validate_full_url

  # Method to generate the short url using Base62
  def short_code
    # Validate if id is null
    return nil if id == nil
    id = self.id
    short_url = ''
    # for each number find the base 62
    while id > 0
      short_url += CHARACTERS[id % 62]
      id /= 62
    end
    # reversing the short_url
    short_url = short_url.reverse
    # Save the short url into DB
    update_column(:short_url, short_url)
    short_url
  end

  # Update title when called in background job
  def update_title!
    uri = URI.parse(full_url)
    body = Net::HTTP.get(uri)
    title = body.match(/<title.*?>(.*)<\/title>/)[1]
    self.update(title: title) unless title.empty?
    rescue => e
    errors.add(:errors, e)
  end

  # Find object in DB by short url
  def self.find_by_short_code(code)
    ShortUrl.find_by_short_url(code)
  end

  # Returns the short code 
  def public_attributes
    self.short_code
  end

  private

  # Validate full url provided 
  def url_validator?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
    false
  end

  # Used to call the url validator and to catch the errors
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
