# frozen_string_literal: true

# The VisitsController contains resources associated with the Visit model,
# representing individual visits to pages with tracking enabled
class VisitsController < ApplicationController
  before_action :set_visits, only: :index

  def index
    filter_by_time
    filter_by_page

    data = @visits.map do |visit|
      VisitSerializer.new(visit).serializable_hash
    end

    render json: { data: }, status: :ok
  end

  def create
    @visit = Visit.build(visit_params)

    if @visit.save
      render json: {
        data: VisitSerializer.new(@visit).serializable_hash
      }, status: :created
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
                User.find(params[:user_id]).visits.includes(:page)
              else
                Visit.includes(:page, :ip_info)
              end
  end

  def filter_by_time
    return unless params[:from].present? || params[:to].present?

    from_time = params[:from]&.to_time || Time.new(0)
    to_time = params[:to]&.to_time || Time.zone.now

    @visits = @visits.visited_between(from_time, to_time)
  end

  def filter_by_page
    page_id = params[:page_id]

    @visits = @visits.for_page(page_id) if page_id.present?
  end
end
