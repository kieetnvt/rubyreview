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
      @rubycritic = RubyCritic::AnalysersRunner.new(file.path).run

      if @rubycritic
        @rubycritic_formated = @rubycritic.first.smells
        @rubycritic_formated.sort_by!{|smell| smell.locations.first.line}
      end

      # offenses with rubocop
      runner = RuboCop::Runner.new({}, RuboCop::ConfigStore.new(Rails.root.join(".rubocop.yml")))
      binding.pry
      @rubocop_offenses = runner.send(:file_offenses, file.path)
      @rubocop_offenses = @rubocop_offenses.reject {|x| ["Style/FileName", "Naming/FileName"].include?(x.cop_name)} if @rubocop_offenses

      file.unlink
    end

    render :index
  end
end
