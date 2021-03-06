module ModelAutoCompleterFilter #:nodoc:
  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Class method to automate the generation of a convenient autocomplete action.
    def auto_complete_belongs_to_for_filter(object, association, method, options={}) #:nodoc:
      define_method("auto_complete_belongs_to_for_filter_#{object}_#{association}_#{method}") do
        find_options = { 
          :conditions => ["LOWER(#{method}) LIKE ?", '%' + params[:filter]["#{association}_#{method}"].downcase + '%'], 
          :order => "#{method} ASC",
          :limit => 10
        }.merge!(options)
      
        klass = object.to_s.camelize.constantize.reflect_on_association(association).class_name.constantize
        @items = klass.find(:all, find_options)
        render :inline => "<%= model_auto_completer_result_filter(@items, '#{method}') %>"
      end
    end
  end
end
