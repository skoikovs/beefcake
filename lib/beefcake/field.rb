require 'beefcake/fixdub'
require 'beefcake/fixflo'
require 'beefcake/lendel'
require 'beefcake/varint'

module Beefcake
  class Field
    attr_accessor :value, :fn

    def initialize(type, fn, opts={})
      @type = type
      @fn   = fn
      @opts = opts
    end

    # TODO: Handle packed=true
    def encode(w)
      encoder = get_encoder
      w << ((@fn<<3) | encoder::Wire)
      encoder.encode(w, value)
    end

    def <=>(b)
      fn <=> b.fn
    end

    ##
    # Determines the encoder needed to encode a Protobuf Type.
    def get_encoder
      case @type
      when :int32, :int64, :uint32, :uint64, :sint32, :sint64, :bool, :enum
        Varint
      when :fixed64, :sfixed64, :double
        Fixdub
      when :fixed32, :sfixed32, :float
        Fixflo
      else
        Lendel
      end
    end
  end
end
