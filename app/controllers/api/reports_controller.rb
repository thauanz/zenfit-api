module Api
  class ReportsController < ApiController
    def index
      @report = Report.new(
        ReportPolicy::Scope.new(current_user, Zentime).resolve,
        report_params).generate
    end

    private

    def report_params
      params.permit(:date_from, :date_to, :user_id)
    end
  end
end
