module ApplicationHelper
  def show_smell(smell)
    "
    <strong> #{smell.type} </strong>
    <strong> Line #{smell.locations.first.line}</strong> =>
    <strong> #{smell.message} </strong>
    "
  end

  def show_best_practice(cop)
    "
    <strong> #{cop.cop_name} </strong>
    <strong> Line #{cop.location.line} </strong> =>
    <strong> #{cop.message} </strong>
    "
  end
end
