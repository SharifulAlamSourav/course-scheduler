module Merb
  module GlobalHelpers
    def flash_message
      unless message.empty?
        message_type = message.keys.first
        message_text = message[message_type]
        partial("shared/flash", {:message_type => message_type, :message_text => message_text})
      end
    end

    def menu
      items = [
        ["home", "/", li_class("dashboard")],
        ["konta", url(:controller => "users"), li_class("users")],
        ["studia", url(:controller => "universities"), li_class("universities", "degrees", "lectures", "lecture_types")],
        ["raporty", url(:controller => "reports"), li_class("reports")],
        ["wyloguj", "/logout"],
      ]
      partial "shared/menu", :menu_items => items
    end

    def submenu
      if submenu_items.empty?
        "Brak submenu"
      else
        partial "shared/submenu", :menu_items => submenu_items
      end
    end

    def error_messages(model)
      errors = model.errors.values.flatten
      partial "shared/error_messages", :errors => errors
    end

    def tabular(klass, ds, controller, columns)
      order = params[:order]
      fields = columns.map { |f, _| f }
      objects = klass.tabular(ds, params[:order], params[:page], fields)
      headers = header_links(params[:order], controller, columns)
      pagination = pagination(klass, ds, controller)
      locals = {
        :objects => objects, :fields => fields,
        :headers => headers, :pagination => pagination,
        :controller_name => controller,
      }
      partial "shared/tabular", locals
    end

    protected
    def li_class(*names)
      names.include?(self.class.name.snake_case) ? "active" : ""
    end

    def header_links(order, controller, columns)
      f, o = order.split(".") rescue nil
      columns.map! do |field, name|
        if field.to_s == f
          if o == "asc"
            order = "%s.desc" % field.to_s
          else
            order = "%s.asc" % field.to_s
          end
        else
          order = "%s.asc" % field.to_s
        end
        [order, name]
      end
      columns.map! { |order, name| link_to(name, url(:controller => controller, :order => order, :id => params[:id])) }
      columns
    end

    def pagination(klass, ds, controller)
      total = ds.unordered.count
      return "" if total == 0
      pages = (total - 1) / klass.per_page + 1
      links = []
      pages.times do |page|
        links << link_to((page + 1).to_s, url(:controller => controller, :order => params[:order], :page => page, :id => params[:id]))
      end
      links.join(" | ")
    end
  end
end
