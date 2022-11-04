class BackendsController < ApplicationController
  before_action :set_coach, only: %i[ edit update destroy ]
  before_action :set_backend, only: %i[ edit update destroy ]
  before_action :set_ticket, only: %i[ edit update destroy ]

  # GET /coach/:coach_id/backends/:id/edit
  def edit
  end

  # PATCH/PUT /coach/:coach_id/backends/:id
  def update
    respond_to do |format|
      if @backend.update(backend_params)
        format.html { redirect_to edit_coach_url(@coach, locale: I18n.locale), notice: "Backend was successfully updated." }
        format.json { render json: @backend, status: :created }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @backend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coach/:coach_id/backends/:id
  def destroy
    @coach.coach_backends.find_by(backend: @backend).destroy
    @backend.destroy

    respond_to do |format|
      format.html { redirect_to edit_coach_url(@coach, locale: I18n.locale), notice: "Backend was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:coach_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_backend
    @backend = Backend.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def backend_params
    params.require(:backend).permit(:name, :link)
  end
end
