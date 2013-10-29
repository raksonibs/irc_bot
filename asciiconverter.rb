class String
  def convert_base(from, to)
    self.to_i(from).to_s(to)
  end
end

p "?".unpack('H*')[0].upcase
