# Rulers

Rulers is a Ruby web framework implemented as a learning exercise, using the concepts presented in Noah Gibbs's "Rebuilding Rails" book.

## Description

This project aims to build a lightweight Ruby web framework from scratch, providing insight into the inner workings of popular frameworks like Ruby on Rails. By following along with the development process, you can gain a deeper understanding of web framework architecture and Ruby programming concepts.

## Features

(List the key features of your framework here. For example:)
- Autoloading
- Convention over configuration
- Routing system
- Controller structure
- View rendering
- Basic ORM with SQLite (Object-Relational Mapping)

## Installation

Add installation instructions here. For example:

```ruby
gem 'rulers', git: 'https://github.com/rodrigo-picanco/rulers.git'
```

## Usage

```ruby

# app/models/a_model.rb
require 'rulers/sqlite_model'

class HelloWorldModel< Rulers::Model::SQLite
end


#  app/controllers/a_controller.rb
class HelloWorldController < Rulers::Controller
  def initialize(env)
    super(env)
  end

  attr_reader :foo

  def index
    @quotes = AModel.all

    render :index
  end

  def show
    @quote = AModel.find(params['id'])

    render :show
  end
end

# app/views/hello_world/index.html.erb
<h1>Hello, World!</h1>


# config/application.rb
module MyApp 
  class Application < Rulers::Application
  end
end


# config.ru
require 'rulers'
require './config/application'

app = MyApp::Application.new

use Rack::ContentType

app.route do
  match ':controller/:id/:action'
  match ':controller/:id', default: { action: 'show' }
  match ':controller', default: { action: 'index' }
end

run app
```

## Acknowledgements

This project was inspired by Noah Gibbs's "Rebuilding Rails" book. While the implementation is original, the concepts and learning approach are based on the book's teachings.

## Disclaimer

This framework is primarily for educational purposes and may not be suitable for production use.
