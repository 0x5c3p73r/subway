class ShortsController < ApplicationController
  before_action :set_coach, only: :show

  rescue_from Errno::ECONNREFUSED, with: :http_request_error

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
    params.permit(
      :target, :url, :group, :upload_path, :include, :exclude, :config,
      :dev_id, :filename, :interval, :rename, :filter_script, :strict,
      :upload, :emoji, :add_emoji, :remove_emoji, :append_type, :tfo,
      :udp, :list, :sort, :sort_script, :script, :insert, :scv, :fdn,
      :expand, :append_info, :prepend, :classic, :tls13, :new_name
    )
  end
end
