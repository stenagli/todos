class Todos
  include HTTParty
  URI = 'https://jsonplaceholder.typicode.com/todos'

  class FetchError < StandardError; end

  # Hash of user_id => # completed todos
  def user_completed_counts 
    user_id_completed_counts = {}

    todos.each do |todo|
      if todo.completed?
        user_id_completed_counts[todo.user_id] ||= 0
        user_id_completed_counts[todo.user_id] += 1
      end
    end

    user_id_completed_counts
  end

  # Set of user_id(s) with most completed todos
  def most_completed_user_ids
    max = 0
    max_user_ids = Set.new

    user_completed_counts.each do |user_id, count|
      if count == max
        max_user_ids.add(user_id)
      elsif count > max
        max_user_ids.clear.add(user_id)
        max = count
      end
    end

    max_user_ids
  end

  # Array of Todo
  def todos 
    if response.success?
      JSON.parse(response.body).map { |todo| Todo.new(todo) }
    else
      raise FetchError
    end
  end

  def response
    @response ||= self.class.get(URI)
  end

  class Todo
    def initialize(todo)
      @todo = todo
    end

    def completed?
      !!@todo['completed']
    end

    def user_id
      @todo['userId']
    end
  end
end
