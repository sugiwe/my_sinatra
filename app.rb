require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def open_json(file)
    File.open(file) { |f| JSON.load(f) }
  end
end

get '/' do
  @hash = open_json("json/db.json") 
  @memos = @hash["memos"]
  @memo_titles = @memos.map{|memo| memo["title"]}
  @memo_ids = @memos.map{|memo| memo["id"]}

  @title = "メモアプリ"
  @content = "たくさんメモしよう！"
  erb :index
end

get '/new' do
  @title = "新規作成 | メモアプリ"
  erb :new
end

get '/detail/:id' do
  @path = params['id']
  @detail_hash = open_json("json/db.json")
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

  hash = open_json("json/db.json")
  hash["memos"] << {"id" => @id, "title" => @memo_title, "body" => @memo_text} # JSONの方で設定していたmemosという配列に要素を追加
  File.open("json/db.json", "w") { |f| JSON.dump(hash, f) } # 更新したhashをJSONオブジェクトに変換してJSONファイルに上書きする

  redirect "/detail/#{@id}"
end

get '/edit/:id' do
  @path = params['id']
  @detail_hash = open_json("json/db.json")
  @detail_memos = @detail_hash["memos"]

  @title = "メモの編集 | メモアプリ"
  erb :edit
end

get '/edit' do
  @title = "メモの編集 | メモアプリ"
  erb :edit
end

post '/edit/:id' do
  @path = params['id']
  @memo_title = params[:memo_title]
  @memo_text = params[:memo_text]

  hash = open_json("json/db.json")
  memos = hash["memos"]
  memos.map do |memo|
    if memo.has_value?(@path) 
      memo.store("title", @memo_title)
      memo.store("body", @memo_text)
    end
  end
  File.open("json/db.json", "w") { |f| JSON.dump(hash, f) } # 更新したhashをJSONオブジェクトに変換してJSONファイルに上書きする

  redirect "/detail/#{@path}"
end

get '/delete/:id' do
  @path = params['id']
  @detail_hash = open_json("json/db.json")
  @detail_memos = @detail_hash["memos"]

  @title = "メモの削除 | メモアプリ"
  @content = "このメモを削除しますか？"
  erb :delete
end

delete '/delete/:id' do
  @path = params['id']
  @detail_hash = open_json("json/db.json")
  @detail_memos = @detail_hash["memos"]
  @detail_memos.delete_if{|memo| memo.has_value?(@path)} # 該当するメモを削除する
  File.open("json/db.json", "w") { |f| JSON.dump(@detail_hash, f) } # 更新したhashをJSONオブジェクトに変換してJSONファイルに上書きする

  redirect "/"
end