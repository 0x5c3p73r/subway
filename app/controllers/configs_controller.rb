class ConfigsController < ApplicationController
  before_action :set_coach, only: %i[ edit update destroy ]
  before_action :set_config, only: %i[ edit update destroy ]
  before_action :set_ticket, only: %i[ edit update destroy ]

  # GET /coaches/:coach_id/configs/:id/edit
  def edit
  end

  # PATCH/PUT /coaches/:coach_id/configs/:id
  def update
    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to edit_coach_url(@coach, locale: I18n.locale), notice: "Config was successfully updated." }
        format.json { render json: @config, status: :created }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coaches/:coach_id/configs/:id
  def destroy
    @coach.coach_configs.find_by(config: @config).destroy
    @config.destroy

    respond_to do |format|
      format.html { redirect_to edit_coach_url(@coach, locale: I18n.locale), notice: "Config was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:coach_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_config
    @config = Config.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def config_params
    params.require(:config).permit(:name, :link)
  end
end
