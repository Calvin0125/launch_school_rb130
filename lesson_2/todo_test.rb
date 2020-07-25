require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todo.rb'

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

  def test_mark_all_undone
    @list.done!
    @list.mark_all_undone
    refute(@todo1.done?)
    refute(@todo2.done?)
    refute(@todo3.done?)
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
    output = <<~OUTPUT
    ------- Today's Todos -------
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_with_done
    output = <<~OUTPUT
    ------- Today's Todos -------
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(0)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT
    ------- Today's Todos -------
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end

  def test_each_iterates
    new_todos = []
    @list.each { |todo| new_todos << todo }
    assert_equal(@todos, new_todos)
  end

  def test_each_return_value
    assert_equal(@list, @list.each { 'do nothing' })
  end

  def test_select
    @list.mark_done_at(1)
    done = @list.select(&:done?)
    assert_equal([@todo2], done.to_a)
  end

  def test_find_by_title
    assert_equal(@todo2, @list.find_by_title("Clean room"))
  end

  def test_all_done
    @todo1.done!
    @todo3.done!
    assert_equal([@todo1, @todo3], @list.all_done.to_a)
  end

  def test_all_not_done
    @todo2.done!
    assert_equal([@todo1, @todo3], @list.all_not_done.to_a)
  end

  def test_mark_done
    @list.mark_done("Buy milk")
    assert(@todo1.done!)
  end
end