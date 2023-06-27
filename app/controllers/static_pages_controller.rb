class StaticPagesController < ApplicationController
  def home
    if strong_params.key?(:flickr_user_id)
      flickr = Flickr.new("fddb934fd8e964338d7dcd1b510dfa8b", ENV['PHOTO_WIDGET_SECRET_KEY'])
      user_id = strong_params[:flickr_user_id]
      @user_not_found = false
      @photo_urls = []
      begin
        @photos = flickr.photos.search user_id: user_id
      rescue
        @user_not_found = true
      else
        @photos.each do |photo|
          info = flickr.photos.getInfo(:photo_id => photo['id'])
          @photo_urls << Flickr.url(info)
        end
      end
    end
  end

  def strong_params
    params.permit(:flickr_user_id, :commit)
  end
end
