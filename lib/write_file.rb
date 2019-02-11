class WriteFile
  def initialize(rankings, header)
    @tables = rankings
    @rankings = rankings
    @header = header
  end

  def create_file
    template_path = File.join(Rails.root, 'app', 'views', 'file_upload', 'template.html.erb')
    template = File.read(template_path)
    result = ERB.new(template).result(binding)

    File.open('public/result.html', 'w+') do |f|
      f.write result
    end
  end

  def create_history_file
    template_path = File.join(Rails.root, 'app', 'views', 'file_upload', 'history_template.html.erb')
    template = File.read(template_path)
    result = ERB.new(template).result(binding)

    File.open('public/result.html', 'w+') do |f|
      f.write result
    end
  end
end
