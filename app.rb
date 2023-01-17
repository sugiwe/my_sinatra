# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

CONNECTION = PG.connect(dbname: 'mydb')

helpers do
  def open_db
    CONNECTION.exec('SELECT * FROM memos')
  end

  def open_row
    CONNECTION.exec("SELECT * FROM memos WHERE id = '#{@id}'")
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  rows = open_db
  @memos = rows.to_a

  @title = 'メモアプリ'
  erb :index
end

get '/memos/new' do
  @title = '新規作成 | メモアプリ'
  erb :new
end

get '/memos/:id' do
  @id = params['id']
  detail_row = open_row
  @detail_memo = detail_row.to_a[0]

  @title = 'メモ | メモアプリ'
  erb :detail
end

post '/memos' do
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]
  id = SecureRandom.uuid
  CONNECTION.exec('INSERT INTO memos VALUES ($1, $2, $3)', [id, memo_title, memo_text])

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  @id = params['id']
  detail_row = open_row
  @detail_memo = detail_row.to_a[0]

  @title = 'メモの編集 | メモアプリ'
  erb :edit
end

patch '/memos/:id' do
  id = params['id']
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]
  CONNECTION.exec('UPDATE memos SET title=$1, body=$2 WHERE id=$3', [memo_title, memo_text, id])

  redirect "/memos/#{id}"
end

get '/memos/:id/delete' do
  @id = params['id']
  detail_row = open_row
  @detail_memo = detail_row.to_a[0]

  @title = 'メモの削除 | メモアプリ'
  @content = 'このメモを削除しますか？'
  erb :delete
end

delete '/memos/:id' do
  id = params['id']
  CONNECTION.exec('DELETE FROM memos WHERE id=$1', [id])

  redirect '/memos'
end
