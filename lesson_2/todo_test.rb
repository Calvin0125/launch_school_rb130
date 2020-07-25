require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative '../lesson_1/todo'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_can_only_add_todo_object
    assert_raises(TypeError) { @list << 42 }
    assert_raises(TypeError) { @list.add('hello') }
  end

  def test_shovel
    todo = Todo.new('do laundry')
    @list << todo
    assert_equal(todo, @list.last)
  end

  def test_add
    todo = Todo.new('do laundry')
    @list.add(todo)
    assert_equal(todo, @list.last)
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) {@list.item_at(5) }
  end

  def test_mark_done_at
    @list.mark_done_at(0)
    assert(@todo1.done?)
    refute(@todo2.done?)
    refute(@todo3.done?)
    assert_raises(IndexError) { @list.mark_done_at(25) }
  end

  def test_mark_undone_at
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_undone_at(1)
    assert(@todo1.done?)
    refute(@todo2.done?)
    assert(@todo3.done?)
    assert_raises(IndexError) { @list.mark_undone_at(25) }
  end

  def test_done!
    @list.done!
    assert(@todo1.done?)
    assert(@todo2.done?)
    assert(@todo3.done?)
    assert(@list.done?)
  end

  def test_remove_at
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
    assert_raises(IndexError) { @list.remove_at(42) }
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ------- Today's Todos -------
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    
    assert_equal(output, @list.to_s)
  end
end