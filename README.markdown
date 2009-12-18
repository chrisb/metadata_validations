# metadata_validations

Validations for Rails models with serialized metadata stored in the database. Provides a convenient way of validating required and optional fields.

## Migrations

If your model doesn't already have a metadata column, create one (the column name is arbitrary):

    class AddMetaDataToAssets < ActiveRecord::Migration
      def self.up
        add_column :assets, :meta, :text
      end

      def self.down
        remove_column :assets, :meta
      end
    end

Metadata columns are required to be text fields. All metadata is stored as a hash with symbolized keys.

## Models

To associate and validate metadata, let's take a look at the model:

    class Asset < ActiveRecord::Base
  
      has_metadata :meta, :required_fields => [ :name, :type ], :optional_fields => [ :author ]

      # ...
  
    end

metadata_validations provide a single new class-level method, `has_metadata`. The first argument is the name of the column. You can use `has_metadata` without specifying `required_fields` or `optional_fields`. The plugin will automatically ensure that default values are specified and will take care of casting keys to symbols.

## Advanced Validations

The `has_metadata` method can also take a proc so that the fields are evaluated at run time. <b>The proc should totally return an array of symbols.</b> This is especially useful if you have polymorphic models or intend to require different fields in different situations. 

Let's take a look at a real-world example:

    class Video < ActiveRecord::Base

      belongs_to :video_type
  
      has_metadata :meta, :required_fields => Proc.new { |v| v.video_type.blank? ? [] : v.video_type.required_fields }

      # ...
    
    end

Each `Video` `belongs_to` a `VideoType` and the database contains each video type's required fields. In this example, the proc also allows for videos without a `VideoType` (in which case there are no required fields).

## The Future

I could see adding: metadata form helpers and magic fields.

Copyright (c) 2009 Chris Bielinski <chris@shadowreactor.com>, released under the MIT license.