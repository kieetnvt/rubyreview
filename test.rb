class Dirty
  def awful(x, y)
    if y
      @screen = widgets.map {|w| w.each {|key| key += 3}}
    end
  end
end
