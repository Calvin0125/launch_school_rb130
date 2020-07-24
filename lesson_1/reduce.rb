def reduce(array, memo = array[0])
  index = 1
  while index < array.length
    memo = yield(memo, array[index])
    index += 1
  end
  memo
end

puts reduce([1, 2, 3, 4, 5]) { |memo, num| memo + num }
puts reduce([1, 2, 3, 4, 5]) { |memo, num| memo * num }
puts reduce(['a', 'b', 'c']) { |memo, value| memo + value }
puts reduce([1, 2, 3, 4, 5], &:+)