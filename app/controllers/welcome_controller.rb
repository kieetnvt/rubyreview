class WelcomeController < ApplicationController
  def index
  end

  def review_code
    @current_code = params[:current_code]
    file = File.new('current_code.rb', 'w+')
    file.write(@current_code)
    file.close
    @analysers = ::RubyCritic::AnalysersRunner.new(Rails.root + 'current_code.rb').run
    @analysers_formated = smells_format
    render :index
  end

  private

    def smells_format
      @analysers.first.smells
    end
end
