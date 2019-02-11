class FileUploadController < ApplicationController
  before_action :check_file_type

  def upload
    file_path = upload_params[:data_file].path
    dates = []
    rows = []
    File.open(file_path, "r") do |f|
      f.each_line.with_index do |line, i|
        if i == 0
          dates = line.strip.split(',')
        else
          rows << line.strip.split(',')
        end
      end
    end

    session[:table_data] = parse_data(dates, rows)
    redirect_back(fallback_location: root_path)
  end

  def big_upload
    file_path = big_upload_params[:data_file].path

    dates = []
    rows = []
    File.open(file_path, "r") do |f|
      f.each_line.with_index do |line, i|
        if i == 0
          dates = line.strip.split(',')
        else
          rows << line.strip.split(',')
        end
      end
    end

    table_data = parse_data(dates, rows)
    filter = Filter.new(table_data)

    from = big_upload_params[:from]
    to = big_upload_params[:to]
    app_name = big_upload_params[:app_name]
    operation = big_upload_params[:operation]
    history = big_upload_params[:history]

    if from.present? && to.present?
      from = display_date(Date.parse(from))
      to = display_date(Date.parse(to))

      if history == 'show'
        tables = filter.history_rankings(from, to)
        header = "#{from} - #{to}"
        WriteFile.new(tables, header).create_history_file
      else
        rankings = from != to ?
          filter.rankings_for_range(from, to, operation) :
          filter.rankings_for_date(from)
        header = "#{from} - #{to}"
        WriteFile.new(rankings, header).create_file
      end
    else
      todays_date = display_date(Date.today)
      rankings = app_name.present? ?
        filter.rankings_for_date(todays_date, app_name.upcase) :
        filter.rankings_for_date(todays_date)
      header = todays_date

      WriteFile.new(rankings, header).create_file
    end

    redirect_to :controller => 'home', :action => 'download_file'
  end

  private

  def upload_params
    params.require(:data).permit(:data_file)
  end

  def big_upload_params
    params.require(:data).permit(:data_file, :from, :to, :app_name, :operation, :history)
  end

  def check_file_type
    if upload_params[:data_file].content_type != 'text/csv'
      flash[:notice] = "WRONG FILE TYPE"
      redirect_to root_path
      return false
    end
  end

  def display_date(date)
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def parse_data(dates, rows)
    table_data = {}

    rows.each do |app_row|
      app_name = app_row[0]
      j = 1

      while j < dates.length do
        if table_data[dates[j]]
           table_data[dates[j]] << [app_name, app_row[j].to_i]
         else
           table_data[dates[j]] = [[app_name, app_row[j].to_i]]
         end
        j += 1
      end
    end

    table_data
  end
end
