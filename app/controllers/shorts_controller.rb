require "net/http"

class ShortsController < ApplicationController
  skip_before_action :set_locale
  before_action :set_coach, only: :show

  rescue_from Faraday::Error, OpenSSL::SSL::SSLError, with: :http_request_error

  # GET /:coach_id
  def show
    render plain: @coach.fetch_content(subscriber_params)
  end

  private

  def set_coach
    @coach = Coach.find(params[:id])
  end

  def http_request_error(exception)
    message = "[#{exception.class}] #{exception.message}"
    respond_to do |format|
      format.any  { render plain: message, status: 400, formats: [:html] }
      format.json { render json: { error: message }, status: 400 }
    end
  end

  def subscriber_params
    all_keys = params.keys.map(&:to_sym)
    params.permit(all_keys)
  end
end
