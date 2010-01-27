class Degrees < Application
  def index
    @university = University[params[:id]]
    self.title = "Kierunki: %s" % [@university.name]
    @degrees = [Degree, Degree.filter(:university_id => @university.id), "degrees", [[:name, "Nazwa"], [:it, "Informatyka?"]]]
    render
  end

  def add
    @university = University[params[:id]]
    @degree = Degree.new(params[:degree] || {})
    self.title = "Dodaj nowy kierunek"
    return render if request.get?
    @degree.save
    redirect(url(:controller => "degrees", :action => "index", :id => @university.id),
             :message => {:notice => "Dodano kierunek"})
  rescue Sequel::ValidationFailed
    self.message[:error] = error_messages(@degree)
    render
  end

  def title
    "Kierunki"
  end

  def submenu_items
    [
      ["pokaż kierunki", url(:controller => "degrees", :action => "index", :id => @university.id)],
      ["dodaj nowy", url(:controller => "degrees", :action => "add", :id => @university.id)],
    ]
  end
end