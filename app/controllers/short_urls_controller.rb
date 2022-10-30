class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: {urls:urls}, status: 200
  end

  def create
    shortUrl = ShortUrl.find_by_full_url(params[:full_url])
    if shortUrl
      render json: {short_code:shortUrl.short_code}, status: 200
    else
      shortUrl = ShortUrl.new(full_url:params[:full_url])
      if shortUrl.save
        shortUrl.update_title!
        UpdateTitleJob.perform_later(shortUrl.id)
        render json: {short_code:shortUrl.short_code}, status: 200
      else
        render json: shortUrl.errors
      end
    end
  end

  def show
    shortUrl = ShortUrl.find_by_short_code(params[:id])
    if shortUrl
      shortUrl.update_attribute(:click_count, shortUrl.click_count + 1)
      redirect_to shortUrl.full_url
    else
      render json: {error: 'Error'}, status: 404
    end
  end

end
