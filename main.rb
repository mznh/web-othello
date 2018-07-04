#!/usr/bin/env ruby
# coding: utf-8


require 'bundler/setup'
require 'sinatra'
require 'haml'
require './othello.rb'



configure do
  set :environment, :production
end

use Rack::Session::Cookie,
  :key => 'rack.session',
#  :domain => 'foo.com',
#  :path => '/',
  :expire_after => 3600,
  :secret => "#{rand(1000)}"

opponent = [0,2,1]
$side_char = [0,"白","黒"]

helpers do
	def init_game 
#init 処理
		session[:othello] = Othello.new
		session[:game_board] = Array.new(8).map{Array.new(8,0)}
		session[:side] = 2
		session[:game_board][3][3] = 1
		session[:game_board][3][4] = 2
		session[:game_board][4][3] = 2
		session[:game_board][4][4] = 1
		session[:othello].game_board = session[:game_board]
	end
end


get '/' do
	if session[:game_board].nil? 
		init_game
	end
	haml :index
end

post '/' do
	if session[:game_board].nil? 
		init_game
	end
	if not params[:pass].nil?
		now = session[:side]
		session[:side] = opponent[now] 
	elsif not  params[:reset].nil?
		init_game
	else 
		input_x,input_y = params[:input_pos].split(/,/).map{|i|i.to_i}
		now = session[:side]
		l = session[:othello].try_put_stone(input_x,input_y,now)
		if l.length != 0
			session[:othello].put_stone(input_x,input_y,now)
			session[:othello].flip_board(l)
			session[:othello].game_board = session[:game_board]
			session[:side] = opponent[now] 
		else 
			puts "okenakatta-"
		end
	end
	redirect '/'
end

get '/json/:pos' do
	content_type :json
	if session[:game_board].nil? 
		init_game
	end
	if not params[:pass].nil?
		now = session[:side]
		session[:side] = opponent[now] 
	elsif not  params[:reset].nil?
		init_game
	else 
		now = session[:side]
		input_x, input_y = params[:pos].split(/,/).map{|i|i.to_i}
		l = session[:othello].try_put_stone(input_x,input_y,now)
		if l.length != 0
			session[:othello].put_stone(input_x,input_y,now)
			session[:othello].flip_board(l)
			session[:othello].game_board = session[:game_board]
			session[:side] = opponent[now] 
		else 
			puts "okenakatta-"
		end
	end
	data = {board:session[:othello].game_board}
	data[:side] = session[:side]
	data.to_json
end

