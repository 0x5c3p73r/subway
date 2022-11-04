class CoachesController < ApplicationController
  before_action :set_coach, only: %i[ show edit update destroy ]
  before_action :set_ticket, only: %i[ show edit update destroy ]

  def index
  end

  def verify_ticket
  end

  def new
    @coach = Coach.new
  end

  def show
  end

  def create
    @coach = Coach.new(coach_params)
    process_subscribes(@coach)

    respond_to do |format|
      if @coach.save
        process_backend(@coach)
        process_config(@coach)

        cookies[@coach.ticket_key] = Rails.cache.read(@coach.ticket_key)
        format.html { redirect_to coach_url(@coach, locale: I18n.locale), notice: "Coach was successfully created." }
        format.json { render json: @coach, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coach.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    process_backend(@coach)
    process_config(@coach)
    process_subscribes(@coach)
    respond_to do |format|
      if @coach.update(coach_params)
        format.html { redirect_to edit_coach_url(@coach, locale: I18n.locale), notice: "Coach was successfully updated." }
        format.json { render json: @coach, status: :created }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coach.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    cookies.delete(@coach.ticket_key)
    @coach.destroy

    respond_to do |format|
      format.html { redirect_to locale_root_url(locale: I18n.locale), notice: "Coach was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def process_backend(coach)
    backend = if (custom_backend = params[:coach][:custom_backend].presence)
      Backend.find_or_create_by(link: custom_backend)
    else
      backend_id = params[:coach][:backends]
      Backend.find(backend_id)
    end

    coach.add_backend(backend)
  end

  def process_config(coach)
    config = if (custom_config = params[:coach][:custom_config].presence)
      Config.find_or_create_by(link: custom_config)
    elsif (config_id = params[:coach][:configs].presence)
      Config.find(config_id)
    else
      # Delete all system configs and set customer config to disable
      coach.clear_enabled_system_configs!
      coach.coach_configs.update_all(enabled: false)
      false
    end

    return unless config

    coach.add_config(config)
  end

  def process_subscribes(coach)
    subscribe_urls = params[:coach][:subscribe_urls]
    links = subscribe_urls.split("\n")
      .map {|n| n.include?("|") ? n.split("|") : n }
      .flatten
      .compact

    subcribes = links.each_with_object([]) do |link, obj|
      # TODO: next if not url matches?
      next if coach.persisted? && coach.subscribes.exists?(link: link)

      name = generate_source_name(link)
      obj << {
        name: name,
        link: link
      }
    end

    coach.subscribes.build(subcribes)
  end

  def generate_source_name(link)
    URI.parse(link).hostname
  end

  def set_coach
    @coach = Coach.find(params[:id])
  end

    def coach_params
    params.require(:coach).permit(
      :name, :target, :description,
      backends_attributes: [ :link ],
      configs_attributes: [ :link ]
    )
  end
end
