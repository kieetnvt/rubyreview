module ApplicationHelper
  def show_smell(smell)
    "<strong> Line #{smell.locations.first.line}</strong> has smell
     <strong> #{smell.message} </strong> "
  end

  def show_best_practice(cop)
    "<strong> Line #{cop.location.line} </strong> has message
    <strong> #{cop.message} </strong> "
  end
end
