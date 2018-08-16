class ReviewController < ApplicationController

  def index
  end

  def review_code
    if params[:current_code] && params[:commit]
      @current_code = params[:current_code]

      # file
      file = Tempfile.new(['anomyous', ".rb"])
      file.write(@current_code)
      file.close

      # smells with ruby critic
      @rubycritic = RubyCritic::AnalysersRunner.new(file.path).run || []
      if @rubycritic
        @rubycritic_formated = @rubycritic.first.smells
        @rubycritic_formated.sort_by!{|smell| smell.locations.first.line}
      end

      # offenses with rubocop
      config                = RuboCop::ConfigStore.new
      path                  = Rails.root.join(".rubocop.yml")
      config.options_config = path
      runner                = RuboCop::Runner.new({}, config)
      @rubocop_offenses     = runner.send(:file_offenses, file.path) || []

      file.unlink
    end
    render :index
  rescue => e
    puts e.message
    puts e.backtrace
    render plain: "Lỗi quá, sorry anh nha! #{e.message}"
  end
end
