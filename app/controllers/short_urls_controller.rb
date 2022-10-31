class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Render top 100 url sorted
  def index
    urls = ShortUrl.order(click_count: :desc).limit(100)
    render status: 200, json: { urls: urls.map{ |u| u.short_code } }
  end

  def create
    # Checks if url is already added
    shortUrl = ShortUrl.find_by_full_url(params[:full_url])
    if shortUrl
      # Render short_code from a located full_url on DB
      render json: {short_code:shortUrl.short_code}, status: 200
    else
      # New intance ShortUrl
      shortUrl = ShortUrl.new(full_url:params[:full_url])
      if shortUrl.save
        # Update title using background job
        UpdateTitleJob.perform_later(shortUrl.id)
        render json: {short_code:shortUrl.short_code}, status: 200
      else
        # if not then render 'errors' 
        render json: shortUrl.errors
      end
    end
  end

  def show
    # Find the full url associate
    shortUrl = ShortUrl.find_by_short_code(params[:id])
    if shortUrl
      # Increase by 1 click_count
      shortUrl.update_attribute(:click_count, shortUrl.click_count + 1)
      # Redirects in browser
      redirect_to shortUrl.full_url
    else
      # if not then render 'Error' 
      render json: {error: 'Error'}, status: 404
    end
  end

end
