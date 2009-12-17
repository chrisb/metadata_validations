# MetadataValidations
module MetadataValidations
  
  module InstanceMethods
          
    def metadata; self.send(metadata_column); end
    def metadata=(value); self.send("#{metadata_column}=",value); end
    
    protected
    
      def after_initialize
        check_empty_metadata
      end
    
      def validate
        check_empty_metadata
        check_required_fields
        super
      end

      def metadata_options
        self.class.metadata_options
      end
      
      def metadata_column
        metadata_options[:column]
      end
      
      def metadata_proc_given?
        metadata_options[:required_fields].is_a?(Proc)
      end
      
      def metadata_required_fields
        metadata_proc_given? ? metadata_options[:required_fields].call(self) : metadata_options[:required_fields]
      end
      
      def check_required_fields
        metadata_required_fields.each { |key| errors.add_to_base "#{key.to_s.capitalize} must be specified" if self.metadata.symbolize_keys[key].blank? }
      end

      def check_empty_metadata
        self.metadata = {} if self.metadata.blank?
      end
    
  end
  
  module ClassMethods
    
    def metadata_options
      read_inheritable_attribute(:metadata_options)
    end
    
    def has_metadata(column,options={})
      serialize column
      before_save :check_empty_metadata
      options[:required_fields] ||= []
      options[:column] = column
      write_inheritable_attribute(:metadata_options,options)
      include InstanceMethods
    end
    
  end
  
end