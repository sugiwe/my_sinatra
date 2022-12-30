# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

helpers do
  def connect_db(file)
    PG::connect(dbname: file)
  end

  def open_db(file)
    connect_db(file).exec( "SELECT * FROM memos" ) 
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  rows = open_db("mydb")
  @memos = rows.map { |row| row }

  @title = 'メモアプリ'
  erb :index
end

get '/memos/new' do
  @title = '新規作成 | メモアプリ'
  erb :new
end

get '/memos/:id' do
  @id = params['id']
  detail_rows = open_db("mydb")
  detail_memos = detail_rows.map { |row| row }
  @detail_memo = detail_memos.find { |memo| memo.fetch('id') == @id }

  @title = 'メモ | メモアプリ'
  erb :detail
end

post '/memos' do
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]
  id = SecureRandom.uuid
  connect_db("mydb").exec( "INSERT INTO memos VALUES ($1, $2, $3)", [id, memo_title, memo_text] )

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  @id = params['id']
  detail_rows = open_db("mydb")
  detail_memos = detail_rows.map { |row| row }
  @detail_memo = detail_memos.find { |memo| memo.fetch('id') == @id }

  @title = 'メモの編集 | メモアプリ'
  erb :edit
end

patch '/memos/:id' do
  id = params['id']
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]
  connect_db("mydb").exec( "UPDATE memos SET title=$1, body=$2 WHERE id=$3", [memo_title, memo_text, id] )

  redirect "/memos/#{id}"
end

get '/memos/:id/delete' do
  @id = params['id']
  detail_rows = open_db("mydb")
  detail_memos = detail_rows.map { |row| row }
  @detail_memo = detail_memos.find { |memo| memo.fetch('id') == @id }

  @title = 'メモの削除 | メモアプリ'
  @content = 'このメモを削除しますか？'
  erb :delete
end

delete '/memos/:id' do
  id = params['id']
  connect_db("mydb").exec( "DELETE FROM memos WHERE id='#{id}'" )

  redirect '/memos'
end
