class VisitsController < ApplicationController
  before_action :set_visits, only: :index

  def index
    filter_by_time
    filter_by_page

    data = @visits.map do |visit|
      VisitSerializer.new(visit).serializable_hash
    end

    render json: { data: data }, status: :ok
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

  def set_visits
   @visits = if params[:user_id].present?
               User.find(params[:user_id]).visits
             else
               Visit.includes(:ip_info)
             end
  end

  def filter_by_time
    from_time = params[:from]&.to_time || Time.new(0)
    to_time = params[:to]&.to_time || Time.zone.now

    if params[:from].present? || params[:to].present?
      @visits = @visits.visited_between(from_time, to_time)
    end
  end

  def filter_by_page
    page_id = params[:page_id]

    @visits = @visits.for_page(page_id) if page_id.present?
  end
end
