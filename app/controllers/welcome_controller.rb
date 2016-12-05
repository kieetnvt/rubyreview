class WelcomeController < ApplicationController

  def index
  end

  def review_code
    @current_code = params[:current_code]

    if @current_code
      file = Tempfile.new(['current_code_', ".rb"])
      file.write(@current_code)
      file.close

      @analysers = ::RubyCritic::AnalysersRunner.new(file.path).run

      if @analysers
        @analysers_formated = @analysers.first.smells
      end

      file.unlink
    end

    render :index
  end
end
