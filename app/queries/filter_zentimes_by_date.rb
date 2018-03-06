class FilterZentimesByDate
  def initialize(relation = Zentime.all)
    @relation = relation
  end

  def search(params = {})
    date_from = params[:date_from].to_date
    date_to = (params[:date_to] || Date.today).to_date
    @relation.where(date_record: date_from..date_to)
  end
end
