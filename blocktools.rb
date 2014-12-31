
def uint1(stream)
  stream.read(1).ord
end

def uint2(stream)
  stream.read(2).unpack('s')[0]
end

def uint4(stream)
  stream.read(4).unpack('I')[0]
end

def uint8(stream)
  stream.read(8).unpack('Q')[0]
end

def hash_with_length(stream, length)
  stream.read(length).unpack('H*')[0]
end

def hash32(stream)
  hash_with_length(stream, 32)
end

def varint(stream)
  size = uint1(stream)
  return size if size < 0xfd
  return uint2(stream) if size == 0xfd
  return uint4(stream) if size == 0xfe
  return uint8(stream) if size == 0xff
  return -1
end

