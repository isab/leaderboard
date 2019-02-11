class HomeController < ApplicationController
  def index
    # clone the table data from the session
    @table_data =  Marshal.load(Marshal.dump(session[:table_data]))

    if @table_data.present?
      filter = Filter.new(@table_data)
      from = home_params[:from]
      to = home_params[:to]
      app_name = home_params[:app_name]
      operation = home_params[:operation]

      if from.present? && to.present?
        @rankings = home_params[:range] == "true" ?
          filter.rankings_for_range(from, to, operation) :
          filter.rankings_for_date(from)
        @header = "#{from} - #{to}"
      else
        todays_date = display_date(Date.today)
        @rankings = app_name.present? ?
          filter.rankings_for_date(todays_date, app_name) :
          filter.rankings_for_date(todays_date)
        @header = todays_date
      end
    end
  end

  def download_file
    send_file(
      "#{Rails.root}/public/result.html",
      filename: "leaderboard.html",
      type: "text/html"
    )

    redirect_to home_index_path
  end

  def filter_by_dates
    from = display_date(Date.parse(filter_dates_params[:from]))
    to = display_date(Date.parse(filter_dates_params[:to]))

    if from == to
      redirect_to home_index_path(:from => from, :to => to, :range => false)
    else
      redirect_to home_index_path(:from => from, :to => to, :range => true)
    end
  end

  def filter_by_app
    app_name = filter_app_params[:app_name]
    redirect_to home_index_path(:app_name => app_name.upcase)
  end

  private

  def home_params
    params.permit(:from, :to, :range, :app_name, :operation)
  end

  def filter_dates_params
    params.require(:filter_dates).permit(:from, :to)
  end

  def filter_app_params
    params.require(:filter_app).permit(:app_name)
  end

  def display_date(date)
    "#{date.month}/#{date.day}/#{date.year}"
  end
end
