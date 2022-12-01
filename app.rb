require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

get '/' do
  @hash = File.open("json/db.json") { |f| JSON.load(f) } # JSONファイル内のJSONオブジェクトをRubyオブジェクトに変換してhashという変数に入れる
  @memos = @hash["memos"]
  @memo_titles = @memos.map{|memo| memo["title"]}
  @memo_ids = @memos.map{|memo| memo["id"]}

  @title = "メモアプリ"
  @content = "たくさんメモしよう！"
  erb :index
end

# メモ：リダイレクトは下記のように設定可能
get '/hoge' do
  redirect 'http://localhost:4567/detail/4933535d-8f82-4d1e-a7bb-a04409ce576f'
end

get '/new' do
  @title = "新規作成 | メモアプリ"
  erb :new
end

get '/detail/:id' do
  @path = params['id']
  @detail_hash = File.open("json/db.json") { |f| JSON.load(f) } # JSONファイル内のJSONオブジェクトをRubyオブジェクトに変換して@detail_hashに入れる
  @detail_memos = @detail_hash["memos"]

  @title = "メモ | メモアプリ"
  erb :detail
end

get '/detail' do
  @title = "メモ | メモアプリ"
  erb :detail
end

post '/detail' do
  @memo_title = params[:memo_title]
  @memo_text = params[:memo_text]
  @id = SecureRandom.uuid # メモにユニークなIDを付ける

  hash = File.open("json/db.json") { |f| JSON.load(f) } # JSONファイル内のJSONオブジェクトをRubyオブジェクトに変換してhashという変数に入れる
  hash["memos"] << {"id" => @id, "title" => @memo_title, "body" => @memo_text} # JSONの方で設定していたmemosという配列に要素を追加
  File.open("json/db.json", "w") { |f| JSON.dump(hash, f) } # 更新したhashをJSONオブジェクトに変換してJSONファイルに上書きする

  redirect "/detail/#{@id}"
end

get '/edit' do
  @title = "メモの編集 | メモアプリ"
  erb :edit
end