# Include hook code here
require File.join(File.dirname(__FILE__), "lib", "metadata_validations")
require File.join(File.dirname(__FILE__), "lib", "metadata_accessors")

ActiveRecord::Base.send(:extend, MetadataValidations::ClassMethods)
ActiveRecord::Base.send(:extend, MetadataAccessors::ClassMethods)