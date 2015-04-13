require 'will_paginate/array'

class WelcomeController < ApplicationController
  def index
    @recipes = Recipe
                .search_by_updated_since(1.week.ago)
                .order("created_at DESC")
                .take(5)
                .paginate(page: params[:page])

    @time_type = "Last Updated"
    render 'index'
  end
end
