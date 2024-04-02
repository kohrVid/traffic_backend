class VisitsController < ApplicationController
  def create
    @visit = Visit.build(visit_params)

    if @visit.save
      render json: { data: @visit.to_json }, status: :created
    else
      render json: {
        errors: ['an error has prevented the visit from being saved']
      }, status: :bad_request
    end
  end

  private

  def visit_params
    params.require(:visit)
      .permit(
        :page_id,
        :user_id,
        :visited_at,
        ip_info_attributes: [:address]
      )
  end
end
