require 'io/console'
require_relative 'blocktools'


class Block
  attr_accessor :magic_number, :blocksize, :version, :previous_hash, :merkle_hash, :time, :bits, :nonce, :transactions

  def initialize(blockchain)
    @magic_number = uint4(blockchain)
    @blocksize = uint4(blockchain)
    @version = uint4(blockchain)
    @previous_hash = hash32(blockchain)
    @merkle_hash = hash32(blockchain)
    @time = uint4(blockchain)
    @bits = uint4(blockchain)
    @nonce = uint4(blockchain)

    transactions_count = varint(blockchain)
    @transactions = Array.new(transactions_count) do
      Transaction.new(blockchain)
    end
  end

  def to_s
    string  = "\n========== New Block ==========\n"
    string += "Magic Number:\t#{@magic_number.to_s(16)}\n"
    string += "Blocksize:\t#{@blocksize}\n"
    string += "Version:\t#{@version}\n"
    string += "Previous Hash:\t#{@previous_hash}\n"
    string += "Merkle Root:\t#{@merkle_hash}\n"
    string += "Time:\t\t#{Time.at(@time)}\n"
    string += "Difficulty:\t#{@bits.to_s(16)}\n"
    string += "Nonce:\t\t#{@nonce}\n"

    string += @transactions.join

    string
  end
end

class Transaction
  attr_accessor :version, :inputs, :outputs, :lock_time

  def initialize(blockchain)
    @version = uint4(blockchain)

    inputs_count = varint(blockchain)
    @inputs = Array.new(inputs_count) do
      TransactionInput.new(blockchain)
    end
    
    outputs_count = varint(blockchain)
    @outputs = Array.new(outputs_count) do
      TransactionOutput.new(blockchain)
    end
    
    @lock_time = uint4(blockchain)
  end

  def to_s
    string  = "\n========== New Transaction ==========\n"
    string += "Version:\t#{@version}\n"

    string += "Inputs\n"
    string += @inputs.join

    string += "Outputs\n"
    string += @outputs.join
    
    string += "Lock Time:\t#{@lock_time}\n"
    string
  end
end

class TransactionInput
  attr_accessor :previous_hash, :transaction_output_id, :script_sign, :sequal_number

  def initialize(blockchain)
    @previous_hash = hash32(blockchain)
    @transactions_out_id = uint4(blockchain)

    script_length = varint(blockchain)
    @script_sign = hash_with_length(blockchain, script_length)
    @sequal_number = uint4(blockchain)
  end

  def to_s
    string  = "Previous Hash:\t#{@previous_hash}\n"
    string += "Tx Out Index:\t#{@transactions_out_id.to_s(16)}\n"
    string += "Script Sign:\t#{@script_sign}\n"
    string += "Sequence:\t#{@sequal_number.to_s(16)}\n\n"
    string
  end
end


class TransactionOutput
  attr_accessor :value, :script_length, :public_key

  def initialize(blockchain)
    @value = uint8(blockchain)
    script_length = varint(blockchain)
    @public_key = hash_with_length(blockchain, script_length)
  end

  def to_s
    string  = "Value:\t\t#{@value}\n"
    
    string += "Public Key:\t#{@public_key}\n\n"
    string
  end
end

st = open("../blk0001.dat", "rb")

while !st.eof?
  puts Block.new(st).to_s
end