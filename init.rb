# Include hook code here
require File.join(File.dirname(__FILE__), "lib", "metadata_validations")
ActiveRecord::Base.send(:extend, MetadataValidations::ClassMethods)