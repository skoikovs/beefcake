require 'beefcake/field'

module Beefcake
  module Message
    module Dsl

      def fields
        @fields ||= []
      end

      def field(rule, name, type, fn)
        field = Field.new(type, fn)
        fields << field

        # Install the getter for the field
        define_method(name) { field.value }

        # Install the setter for the field
        define_method(name.to_s+"=") { |v| field.value = v }
      end

      def required(name, type, fn)
        field(:required, name, type, fn)
      end

      def optional(name, type, fn)
        field(:optional, name, type, fn)
      end

    end


    def self.included(o)
      o.extend(Dsl)
    end

    def initialize(attrs)
      attrs.each {|n, v| __send__(n.to_s+"=", v) }
    end

    def fields
      self.class.fields.sort
    end

    def encode(w)
      fields.each {|f| f.encode(w) }
      w # Always return the writer from encodes
    end
  end
end
