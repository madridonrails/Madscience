module IndexOrder
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    
    def has_sortable_fields
      define_method('create_query_order_and_direction') do
        @index_order_field = params[:index_order_field]
        @index_order_direction = params[:index_order_direction]
        @index_order = "#{@index_order_field} #{@index_order_direction}" unless @index_order_field.blank?
      end
      instance_eval('private :create_query_order_and_direction')
      instance_eval('before_filter :create_query_order_and_direction, :only => :index')
    end

    
  end
end
