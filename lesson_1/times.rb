def times(num)
  i = 0
  while i < num
    yield(i)
    i += 1
  end
  num
end

puts times(5) { |num| puts num }