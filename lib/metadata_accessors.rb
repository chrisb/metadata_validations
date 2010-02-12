module MetadataAccessors
  module ClassMethods
    def meta_accessor(column,*keys)
      keys.each do |accessor|
        define_method "#{accessor}=" do |argument|
          self.send "#{column}=", {} if self.send(column).nil?
          self.send(column)[accessor.to_sym] = argument
        end
        define_method accessor do
          self.send(column)[accessor]
        end
      end
    end
  end
end