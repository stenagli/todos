class TodosController < ApplicationController
  def index
    todos = Todos.new
    @user_completed_counts = todos.user_completed_counts
    @most_completed_user_ids = todos.most_completed_user_ids
  rescue Todos::FetchError
    render :error
  end
end
