# frozen_string_literal: true

require "active_record"

require_relative "activerecord_lazy_columns/version"

module ActiveRecordLazyColumns
  # Extension for Active Record to add `lazy_columns` method with an ability
  # to lazily load specific columns.
  #
  module ModelExtension
    attr_writer :lazy_loaded_columns

    def lazy_loaded_columns
      @lazy_loaded_columns || []
    end

    # Declare some columns to be loaded lazily.
    #
    # @example
    #   class Action < ApplicationRecord
    #     lazy_columns :comments
    #   end
    #
    def lazy_columns(*columns)
      columns = columns.map(&:to_s)
      self.lazy_loaded_columns = columns

      default_scope { select(column_names - columns) }
      columns.each { |column| define_lazy_reader_for(column) }
    end

    private
      def define_lazy_reader_for(column)
        define_method(column) do
          unless has_attribute?(column)
            value = self.class.unscoped.where(id: [id]).pick(column)
            write_attribute(column, value)
            clear_attribute_changes([column])
          end

          read_attribute(column)
        end
      end
  end

  # @private
  module RelationExtension
    def count(column_name = nil)
      if column_name.nil? && klass.lazy_loaded_columns.any?
        column_name = :all
      end

      super
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend ActiveRecordLazyColumns::ModelExtension

  ActiveRecord::Relation.prepend(ActiveRecordLazyColumns::RelationExtension)
end
