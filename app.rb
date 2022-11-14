require 'sinatra'
require 'sinatra/reloader'

get '/' do
  @title = "メモアプリ"
  @content = "たくさんメモしようぜ！"
  erb :index
end

get '/new' do
  @title = "新規作成 | メモアプリ"
  erb :new
end

get '/detail' do
  @title = "メモ | メモアプリ"
  erb :detail
end

get '/edit' do
  @title = "メモの編集 | メモアプリ"
  erb :edit
end