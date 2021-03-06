class Universities < Application
  def index
    @universities = [University, University.dataset, "universities", [[:name, "Nazwa"], [:pensum, "Pensum?"]]]
    render
  end

  def show
    redirect(url(:controller => "degrees", :action => "index", :id => params[:id]))
  end

  def edit
    @university = University[params[:id]]
    return render if request.get?
    @university.update(params[:university])
    redirect(url(:controller => "universities"),
             :message => {:notice => "Zaktualizowano!"})
  rescue Sequel::ValidationFailed
    self.message[:notice] = error_messages(@university)
    render
  end

  def add
    @university = University.new(params[:university] || {})
    self.title = "Dodaj nowe studia"
    return render if request.get?
    @university.save
    redirect(url(:controller => "universities"),
             :message => {:notice => "Dodano uniwersytet"})
  rescue Sequel::ValidationFailed
    self.message[:error] = error_messages(@university)
    render
  end

  def delete
    @university = University[params[:id]]
    self.title = "Czy na pewno usunąć?"
    return render if request.get?
    @university.destroy
    redirect(url(:controller => "universities"), :message => {:notice => "Uczelnia usunięta"})
  end

  def title
    "Studia"
  end

  def submenu_items
    [
      ["pokaż studia", url(:controller => "universities")],
      ["dodaj studia", url(:controller => "universities", :action => "add")],
      ["typy zajęć", url(:controller => "lecture_types", :action => "index")],
    ]
  end
end
