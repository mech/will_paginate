require 'mongoid'
require 'will_paginate/collection'

module WillPaginate
  module Mongoid
    module CriteriaMethods
      def paginate(options = {})
        extend CollectionMethods
        @current_page = WillPaginate::PageNumber(options[:page] || @current_page || 1)
        @page_multiplier = current_page - 1
        pp = (options[:per_page] || per_page || WillPaginate.per_page).to_i
        limit(pp).skip(@page_multiplier * pp)
      end

      def per_page(value = :non_given)
        value == :non_given ? options[:limit] : limit(value)
      end

      def page(page)
        paginate(:page => page)
      end
    end

    module CollectionMethods
      include WillPaginate::CollectionMethods
      attr_reader :current_page

      def total_entries
        @total_entries ||= count
      end

      def offset
        @page_multiplier * per_page
      end
    end

    ::Mongoid::Criteria.send(:include, CriteriaMethods)
  end
end