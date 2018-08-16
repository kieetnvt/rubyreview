module ApplicationHelper
  def show_smell(smell)
    "
    <strong> Line #{smell.locations.first.line} => #{smell.type} #{smell.message} </strong>
    "
  end

  def show_rubocop(cop)
    "
    <strong> Line #{cop.location.line} => #{cop.message} </strong>
    "
  end
end
