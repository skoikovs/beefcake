require 'beefcake/buffer/base'

module Beefcake

  class Buffer

    def read_info
      n = read_uint64
      [n >> 3, n & 0x7]
    end

    def read_lendel
      read(read_uint64)
    end

    def read_fixed32
      bytes = read(4)
      bytes.unpack("V").first
    end

    def read_fixed64
      bytes = read(8)
      x, y = bytes.unpack("VV")
      x + (y << 32)
    end

    def read_int64
      n = read_uint64
      if n > MaxInt64
        n -= (1 << 64)
      end
      n
    end
    alias :read_int32 :read_int64

    def read_uint64
      n = shift = 0
      while true
        if shift >= 64
          raise BufferOverflow, "varint"
        end
        b = buf.slice!(0)
        n |= ((b & 0x7F) << shift)
        shift += 7
        if (b & 0x80) == 0
          return n
        end
      end
    end
    alias :read_uint32 :read_uint64

    def read_sint32
      n = read_uint32
      (n >> 1) ^ -(n & 1)
    end

    def read_sfixed32
      n = read_fixed32
      (n >> 1) ^ -(n & 1)
    end

    def read_float
      bytes = read(4)
      bytes.unpack("e").first
    end

    def read_double
      bytes = read(8)
      bytes.unpack("E").first
    end

    def read_bool
      read_int32 != 0
    end

  end

end
