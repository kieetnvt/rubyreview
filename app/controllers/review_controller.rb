class ReviewController < ApplicationController

  def index
  end

  def review_code
    @current_code = params[:current_code]

    if @current_code
      # file
      file = Tempfile.new(['anomyous', ".rb"])
      file.write(@current_code)
      file.close

      # smells
      @rubycritic = RubyCritic::AnalysersRunner.new(file.path).run rescue nil

      if @rubycritic
        @rubycritic_formated = @rubycritic.first.smells
        @rubycritic_formated.sort_by!{|smell| smell.locations.first.line}
      end

      # offenses
      runner = RuboCop::Runner.new({}, RuboCop::ConfigStore.new)
      @rubocop_offenses = runner.send(:file_offenses, file.path)
      @rubocop_offenses = @rubocop_offenses.reject {|x| x.cop_name == "Style/FileName"} if @rubocop_offenses

      file.unlink
    end

    render :index
  end
end
