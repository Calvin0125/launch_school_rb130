class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

class TodoList
  attr_reader :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def size
    todos.size
  end

  def add(todo)
    raise(TypeError, "Can only add todo objects") unless todo.instance_of?(Todo)
    todos << todo
  end

  alias_method :<<, :add

  def first
    todos.first
  end

  def last
    todos.last
  end

  def to_a
    todos.clone
  end

  def done?
    todos.each do |todo|
      return false unless todo.done?
    end
    true
  end

  def item_at(index)
    todos.fetch(index)
  end

  def mark_done_at(index)
    item_at(index).done!
  end

  def mark_undone_at(index)
    item_at(index).undone!
  end

  def done!
    todos.each(&:done!)
  end

  alias_method :mark_all_done, :done!

  def mark_all_undone
    todos.each(&:undone!)
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(index)
    todos.delete(item_at(index))
  end

  def to_s
    strings = ''
    todos.each { |todo| strings += "#{todo.to_s}\n" }
    "------- Today's Todos -------\n#{strings}"
  end

  def each
    todos.each { |todo| yield(todo) }
    self
  end

  def select
    list = TodoList.new(title)
    todos.each do |todo|
      list << todo if yield(todo)
    end
    list
  end

  def find_by_title(title)
    each { |todo| return todo if todo.title == title }
    nil
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(title)
    each { |todo| todo.done! if todo.title == title }
  end
    
  private

  attr_accessor :todos
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list.add(todo1)
list.add(todo2)
list << todo3
list.mark_all_done
puts list
list.mark_all_undone
puts list
