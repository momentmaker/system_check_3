require 'pry'
require 'pg'
require 'sinatra'
require 'sinatra/reloader'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

def get_list
  query = 'SELECT id, name FROM recipes ORDER BY name;'
end

def get_recipe
  query = 'SELECT recipes.id, recipes.name AS recipe_name, ingredients.name AS ingredient_name, recipes.instructions, recipes.description
  FROM recipes LEFT OUTER JOIN ingredients ON recipes.id = recipe_id WHERE recipes.id = $1;'
end

get '/recipes' do
  db_connection do |conn|
    @list = conn.exec(get_list)
  end

  erb :recipes
end

get '/recipes/:id' do
  id = params[:id]

  db_connection do |conn|
    @recipe = conn.exec_params(get_recipe, [id])
  end
  #binding.pry
  erb :recipe
end
