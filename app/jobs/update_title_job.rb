class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    # Find short_url model
    short_url = ShortUrl.find(short_url_id)
    # Call method to update the title
    short_url.update_title!
  end
end
