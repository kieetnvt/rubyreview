module ApplicationHelper
  def show_smell(smell)
    "
    <strong> Line #{smell.locations.first.line} => #{smell.message} </strong>
    "
  end

  def show_best_practice(cop)
    "
    <strong> Line #{cop.location.line} => #{cop.message} </strong>
    "
  end
end
