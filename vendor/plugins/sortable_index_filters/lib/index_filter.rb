module IndexFilter
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def has_index_filters(methods = {})
      define_method('create_filter_and_conditions_objects') do
        @filter = params[:filter] unless @filter
        @conditions = [' 1 = 1 '] unless @conditions
      end

      define_method('add_conditions') do
        unless @filter.blank?
          methods.keys.each do |method| logger.info "argument: #{method}"
            unless @filter[method].blank?
              case methods[method]
                when :like then
                  @conditions[0] << " AND #{method.to_s} LIKE ? "
                  @conditions << "%#{@filter[method]}%"
                when :equal then
                  @conditions[0] << " AND #{method.to_s} = ? "
                  @conditions << "#{@filter[method]}"
                when :greater then
                  @conditions[0] << " AND #{method.to_s} > ? "
                  @conditions << "#{@filter[method]}"
                when :less then
                  @conditions[0] << " AND #{method.to_s} < ? "
                  @conditions << "#{@filter[method]}"
                when :greater_or_equal then
                  @conditions[0] << " AND #{method.to_s} >= ? "
                  @conditions << "#{@filter[method]}"
                when :less_or_equal then
                  @conditions[0] << " AND #{method.to_s} <= ? "
                  @conditions << "#{@filter[method]}"
              end
            end
            logger.info "conditions: #{@conditions}"
          end
        end
      end

      instance_eval('private :create_filter_and_conditions_objects')
      instance_eval('private :add_conditions')
      instance_eval('before_filter :create_filter_and_conditions_objects, :only => :index')
      instance_eval('before_filter :add_conditions, :only => :index')
    end
  end
end
