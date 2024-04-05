class VisitsController < ApplicationController
  def index
    page_id = params[:page_id]
    from_time = params[:from]&.to_time || Time.new(0)
    to_time = params[:to]&.to_time || Time.zone.now

    visits = Visit.includes(:ip_info).visited_between(from_time, to_time)
    visits = visits.for_page(page_id) if page_id.present?

    @visits = visits&.map do |visit|
      VisitSerializer.new(visit).serializable_hash
    end

    render json: { data: @visits }, status: :ok
  end

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
