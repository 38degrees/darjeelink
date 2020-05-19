# frozen_string_literal: true

module Darjeelink
  class ShortLinksController < Darjeelink::ApplicationController
    skip_before_action :check_ip_whitelist, only: :show
    skip_before_action :authenticate, only: :show

    before_action :check_url_present, only: :create
    before_action :check_url_valid, only: :create

    class ShortLinkNotFoundError < StandardError
    end

    def index
      @short_links = Darjeelink::ShortLink.search(params[:query])
                                          .order(id: 'desc')
                                          .paginate(page: params[:page], per_page: 20)
    end

    def new
    end

    def create
      begin
        Darjeelink::ShortLink.create!(url: params[:url], shortened_path: params[:shortened_path])
      rescue ActiveRecord::RecordNotUnique
        flash[:error] = "#{params[:shortened_path]} already used! Choose a different custom path"
        return redirect_to(darjeelink.new_short_link_path)
      end

      redirect_to(darjeelink.short_links_path)
    end

    def edit
      @short_link = Darjeelink::ShortLink.find(params[:id])
    end

    def update
      @short_link = Darjeelink::ShortLink.find(params[:id])
      @short_link.update!(short_link_params)

      redirect_to(darjeelink.short_links_path)
    end

    def show
      shortened_path = CGI.escape(params[:id])
      short_link = Darjeelink::ShortLink.ifind(shortened_path)

      if short_link.nil?
        log_missing_shortlink(shortened_path)
        return redirect_to(Darjeelink.fallback_url)
      end

      short_link.update!(visits: short_link.visits + 1)
      redirect_to(build_url(short_link.url))
    end

    private

    def log_missing_shortlink(shortened_path)
      Rails.logger.warn("ShortLink not found: #{shortened_path}")
    end

    def build_url(url)
      uri = URI(url)

      original_params = Rack::Utils.parse_query(uri.query)
      # Strong params - throws an error if we just use except.  So we have to
      # permit everything first
      new_params = params.permit!.except(:controller, :action, :id)

      short_link_params = merge_params(original_params, new_params)

      # Prevents adding a ? to the end of the url if there are no params
      uri.query = short_link_params.to_query if short_link_params.present?

      uri.to_s
    end

    def merge_params(original_params, new_params)
      # if there are duplicates, new params value will take priority
      original_params.merge(new_params) do |_key, original_value, new_value|
        if original_value.present? && new_value.present?
          new_value
        elsif original_value.present?
          original_value
        else
          new_value
        end
      end
    end

    def short_link_params
      params.require(:short_link).permit(:url, :shortened_path)
    end

    def check_url_present
      return if params[:url].present?

      flash[:error] = 'URL cannot be blank'
      redirect_to(darjeelink.new_short_link_path)
    end

    def check_url_valid
      return if params[:url] =~ URI::DEFAULT_PARSER.make_regexp

      flash[:error] = 'URL is not valid.  Does it have https:// and are there any spaces?'
      redirect_to(darjeelink.new_short_link_path)
    end
  end
end
