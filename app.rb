require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  @title = "メモアプリ"
  @content = "たくさんメモしよう！"
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

post '/detail' do
  @memo_title = params[:memo_title]
  @memo_text = params[:memo_text]

  hash = File.open("json/db.json") { |f| JSON.load(f) } # JSONファイル内のJSONオブジェクトをRubyオブジェクトに変換してhashという変数に入れる
  hash["memos"] << {"id" => 12345, "title" => @memo_title, "body" => @memo_text} # JSONの方で設定していたmemosという配列に要素を追加
  File.open("json/db.json", "w") { |f| JSON.dump(hash, f) } # 更新したhashをJSONオブジェクトに変換してJSONファイルに上書きする

  @title = "#{@memo_title} | メモアプリ" #HTMLのTitleタグ
  erb :detail
end

get '/edit' do
  @title = "メモの編集 | メモアプリ"
  erb :edit
end