class Filter
  def initialize(table_data)
    @table_data = table_data
  end

  def comparison_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end

  def date_exists?(date)
    @table_data[date].present?
  end

  def sort_by_descending(rankings)
    sorted = rankings.sort_by{|app| app[1]}.reverse!
    sorted.map.with_index{|rank, i| rank.unshift(i+1)}
  end

  def rankings_for_date(date, app_name=nil)
    return [] if !date_exists?(date)

    sorted_rankings = sort_by_descending(@table_data[date])

    if app_name
      return sorted_rankings.select!{|app_downloads| app_downloads[1] == app_name}
    else
      return sorted_rankings.first(10)
    end
  end

  def loop_and_op_data(dates_in_range, op)
    rankings = {}
    dates_in_range.each do |date|
      data = @table_data[date]
      data.each do |app_downloads|
        if rankings[app_downloads[0]]
          prev = rankings[app_downloads[0]]
          curr = app_downloads[1]
          if op == 'SUM'
            rankings[app_downloads[0]] += curr
          elsif op == 'MAX'
            rankings[app_downloads[0]] = prev < curr ? curr : prev
          elsif op == 'MIN'
            rankings[app_downloads[0]] = prev > curr ? curr : prev
          end
        else
          rankings[app_downloads[0]] = app_downloads[1]
        end
      end
    end
    rankings
  end

  def avg_data(dates_in_range)
    summed = loop_and_op_data(dates_in_range, 'SUM')
    dividend = dates_in_range.length

    summed.to_a.map{|sum| [sum[0], sum[1]/dividend]}.to_h
  end

  def rankings_for_range(from, to, operation)
    operation = operation || 'SUM'
    dates_in_range = @table_data.keys.select!{|date|
      comparison_date(date) >= comparison_date(from) && comparison_date(date) <= comparison_date(to)
    }
    operated_data = {}

    if operation == 'AVG'
      operated_data = avg_data(dates_in_range)
    elsif ['SUM', 'MIN', 'MAX'].include?(operation)
      operated_data = loop_and_op_data(dates_in_range, operation)
    else
      return []
    end

    sort_by_descending(operated_data.to_a).first(10)
  end

  def history_rankings(from, to)
    result = {}
    dates_in_range = @table_data.keys.select!{|date|
      comparison_date(date) >= comparison_date(from) && comparison_date(date) <= comparison_date(to)
    }

    dates_in_range.each do |date|
      result[date] = rankings_for_date(date)
    end

    result
  end
end
