def each(array)
  index = 0
  while index < array.length
    yield(array[index])
    index += 1
  end
  array
end

each([1, 2, 3]) { |num| puts num }