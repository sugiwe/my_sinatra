# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def open_json(file)
    File.open(file) { |f| JSON.parse(f.read) }
  end

  def overwrite_json(file, hash)
    File.open(file, 'w') { |f| JSON.dump(hash, f) }
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect "/memos"
end

get '/memos' do
  hash = open_json('json/db.json')
  @memos = hash['memos']

  @title = 'メモアプリ'
  erb :index
end

get '/memos/new' do
  @title = '新規作成 | メモアプリ'
  erb :new
end

get '/memos/:id' do
  @path = params['id']
  detail_hash = open_json('json/db.json')
  @detail_memos = detail_hash['memos']

  @title = 'メモ | メモアプリ'
  erb :detail
end

post '/memos' do
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]
  id = SecureRandom.uuid

  hash = open_json('json/db.json')
  hash['memos'] << { 'id' => id, 'title' => memo_title, 'body' => memo_text }
  overwrite_json('json/db.json', hash)

  redirect "/memos/#{id}"
end

get '/memos/:id/edit' do
  @path = params['id']
  detail_hash = open_json('json/db.json')
  @detail_memos = detail_hash['memos']

  @title = 'メモの編集 | メモアプリ'
  erb :edit
end

patch '/memos/:id' do
  id = params['id']
  memo_title = params[:memo_title]
  memo_text = params[:memo_text]

  hash = open_json('json/db.json')
  memos = hash['memos']
  memos.map do |memo|
    if memo.value?(id)
      memo['title'] = memo_title
      memo['body'] = memo_text
    end
  end
  overwrite_json('json/db.json', hash)

  redirect "/memos/#{id}"
end

get '/memos/:id/delete' do
  @path = params['id']
  detail_hash = open_json('json/db.json')
  @detail_memos = detail_hash['memos']

  @title = 'メモの削除 | メモアプリ'
  @content = 'このメモを削除しますか？'
  erb :delete
end

delete '/memos/:id' do
  path = params['id']
  detail_hash = open_json('json/db.json')
  detail_memos = detail_hash['memos']
  detail_memos.delete_if { |memo| memo.value?(path) }
  overwrite_json('json/db.json', detail_hash)

  redirect '/memos'
end
