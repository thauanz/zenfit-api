class Report
  attr_reader :date_from, :date_to, :data

  Data = Struct.new(:week_start, :week_end, :average, :label)

  def initialize(repository = Zentime, params = {})
    @repository = repository.extending(Scopes)
    @date_from = (params[:date_from].presence || default_date_from).to_date
    @date_to = (params[:date_to].presence || default_date_to).to_date
    @user_id = params[:user_id].to_i
  end

  def generate
    tap(&:generate_report_data)
  end

  protected

  def generate_report_data
    reports = @repository.filter_by_date(@date_from, @date_to).joins(:user).filter_by_user(@user_id)
      .select("DATE_TRUNC('week', date_record) AS date_week, AVG(time_record) AS time_avg")
      .order('date_week')
      .group('date_week')

    @data = reports.map do |report|
      week_start = format_date(report.date_week.to_date)
      week_end = format_date(report.date_week.end_of_week.to_date)
      label = "#{week_start} to #{week_end}"
      time_avg = report.time_avg.to_f.round(2)

      Data.new(week_start, week_end, time_avg, label)
    end
  end

  def format_date(date)
    date.strftime('%d/%m/%Y')
  end

  def default_date_from
    Date.today - 4.weeks
  end

  def default_date_to
    Date.today
  end

  module Scopes
    def filter_by_date(date_from, date_to)
      FilterZentimesByDate.new(self).search(
        date_from: date_from, date_to: date_to
      )
    end

    def filter_by_user(id)
      if id > 0
        where(user_id: id)
      else
        self
      end
    end
  end
end
