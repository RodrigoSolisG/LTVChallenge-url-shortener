class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: {urls:urls}
  end

  def create
    shortUrl = ShortUrl.new(full_url:params[:full_url])
    if shortUrl.save
      render json: {short_code:shortUrl}
    else
      render json: {error:shortUrl.errors}
    end
  end

  def show
  end

end
