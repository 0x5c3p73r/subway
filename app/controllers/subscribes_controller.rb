class SubscribesController < ApplicationController
  before_action :set_coach, only: %i[ edit update destroy ]
  before_action :set_subscribe, only: %i[ show edit update destroy ]
  before_action :verify_ticket, only: %i[ edit update destroy ]

  # GET /coach/:coach_id/subscribes/:id/edit
  def edit
  end

  # PATCH/PUT /coach/:coach_id/subscribes/:id
  def update
    respond_to do |format|
      if @subscribe.update(subscribe_params)
        format.html { redirect_to edit_coach_url(@coach), notice: "Subscribe was successfully updated." }
        format.json { render json: @subscribe, status: :created }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subscribe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coach/:coach_id/subscribes/:id
  def destroy
    @coach.coach_subscribes.find_by(subscribe: @subscribe).destroy
    @subscribe.destroy

    respond_to do |format|
      format.html { redirect_to edit_coach_url(@coach), notice: "Subscribe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_coach
    @coach = Coach.find(params[:coach_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_subscribe
    @subscribe = Subscribe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subscribe_params
    params.require(:subscribe).permit(:name, :link)
  end
end
