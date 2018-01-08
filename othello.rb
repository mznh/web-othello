#!/usr/bin/env ruby
# encoding : utf-8


$ERROR_OUT_OF_RANGE = 10
class Fixnum
	def in_range? a,b 
		a <= self and self <= b
	end
end
class Othello
	attr_accessor :game_board
	def initialize
		puts "Let's Othello."
## board[x][y] ってことで
## 0 = blank ,1 = black , 2 = white
		@game_board = Array.new(8).map{Array.new(8,0)}
		@game_char = [" ","@","O"]
		@opponent = [0,2,1]
	  @input_x = @input_y = 0
# 最初の盤面構成
		put_stone(3,3,2)
		put_stone(4,3,1)
		put_stone(3,4,1)
		put_stone(4,4,2)
	end

	def print_board 
		puts "  01234567"
		puts " +-------X>"
		@game_board.each_with_index do |l,i|
			print i != 7 ? "#{i}|" : "#{i}Y"  
			l.each do |i|  
				print @game_char[i]
			end
			puts ""
		end
		puts " V"
	end
	def get_stone(x,y)
		if x.in_range?(0,7) and y.in_range?(0,7)
			@game_board[x][y] 
		else
			$ERROR_OUT_OF_RANGE
		end
	end
	def put_stone(x,y,t) # [x]][y] = tにする
		if x.in_range?(0,7) and y.in_range?(0,7)
			@game_board[x][y] = t 
		else
			puts "error!"
			$ERROR_OUT_OF_RANGE
		end
	end
## x,yにfを置くとどうなるか（ひっくり返る石のリストを返す）
## おけない場合[] を返す
	def try_put_stone(x,y,f)  
		vect = [[0,-1],[1,-1],[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1]]
		origin_flag = f
		flip_list =[]
		unless get_stone(x,y) == 0 #おけない
			return []
		end
		vect.map do |i|	
			tmp_list = []
			next_flag = 0
			dx,dy = i[0],i[1]
			x_n,y_n = x,y 
			loop do 
				x_n,y_n = x_n+dx,y_n+dy
				next_flag = get_stone(x_n,y_n) 
				if next_flag ==$ERROR_OUT_OF_RANGE 
					#実はとくにエラーというわけではない
					break
				end
				# 敵なら進む
				unless next_flag == @opponent[origin_flag]
					break
				end
				tmp_list << [x_n,y_n]
			end
#敵の列を抜けた後、味方ならば(挟んでたら
			if next_flag == origin_flag
				flip_list.concat(tmp_list)
			end
		end
		flip_list
	end
	def flip_board(f_list)
		f_list.each do |i|
			now = get_stone(i[0],i[1])
			put_stone(i[0],i[1],@opponent[now])
		end
	end
	def input_stone_pos(flag)
		print @game_char[flag] + "'s turn. Please input [X Y] "
		in_y,in_x = gets.strip.split(/ /).map{|i| i.to_i}
		#in_x = (0..7).to_a.sample
		#in_y = (0..7).to_a.sample
		if in_x.nil? or in_y.nil?
			return -1,-1
		end
		return in_x,in_y
	end
	def pass?(f) #f側がパスしなくてはならないかどうか
		8.times do |i| 
			8.times do |j| 
				if try_put_stone(i,j,f) != []
					return false
				end
			end
		end
		return true
	end
	def play 
		flag = 1
		loop do 
			print_board
			if pass?(flag) 
				puts "Pass!"
				if pass?(@opponent[flag])
					puts "Finish!!"
					break
				end
				flag = @opponent[flag]
			else 
				@input_x,@input_y = input_stone_pos(flag)
				l=try_put_stone(@input_x,@input_y,flag)
				if l.length !=0 
					put_stone(@input_x,@input_y,flag)
					flip_board(l)
					flag = @opponent[flag]
				else 
					puts "置けませんて"
				end
			end
		end
		puts "OWARI"
	end
end

#game = Othello.new()

#game.play

