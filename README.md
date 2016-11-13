# Chatex

[![Build Status](https://img.shields.io/travis/sylviot/chatex.svg?style=flat-square
"Build Status")](https://travis-ci.org/sylviot/chatex)

A simple chat using WebSocket - [Live demo](http://chatex-live.herokuapp.com/index.html)

## Techs

#### Backend
* [Elixir](https://github.com/elixir-lang/elixir)
* [Cowboy](https://github.com/ninenines/cowboy)
* [Ranch](https://github.com/ninenines/ranch)
* [JSON](https://github.com/cblage/elixir-json)

#### Frontend
* [SemanticUI](https://github.com/Semantic-Org/Semantic-UI)
* [VueJS](https://github.com/vuejs/vuejs.org)

## How use

Download dependences
```elixir
mix deps.get
```

Run application with iex
```elixir
iex -S mix
```

Default PORT is 4000 set in file [chat.ex](https://github.com/sylviot/chatex/blob/master/lib/chat.ex#L47)

Open browser in [localhost:4000/index.html](http://localhost:4000/index.html)

Enjoy :smile: