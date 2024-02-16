require "yaml"

class GameInstance
  attr_accessor :stick
  def initialize
    @stick = ''
  end
end


class Game

  def get_word
    #Load the words from the txt file
    file = File.open("words.txt")
    words = file.readlines.map(&:chomp)
    #select random word between 5 and 12 chracters
    filtered_words = words.select {|word| word.size > 4 && word.size < 13}
    word = filtered_words.sample
    file.close
    word
  end


  def update_stick( input, word, stick, incorrect_chars)
    if word.include?(input)
      word.each_with_index do |char, index|
        stick[index] = input if char == input
      end
    else
      incorrect_chars << input unless incorrect_chars.include?(input)
    end
  end

  def get_input
    print "Enter character or 1 to save: "
    input = gets.chomp.downcase
    if input == '1'
      #if user select save the current user can save the current game
      saved_game = YAML::dump(game)
      puts "game saved successfuly!"
      get_input()
    end
    input
  end


  def start
    while true
      puts " Press 1 to start"
      puts " Press 2 to load saved games "
      puts " Press 3 to exit"
      input = gets.chomp
      case input
      when "1"
        hangman
      when "2"
        #display saved games
      when "3"
       return false
      else
        puts "You gave me #{input} i don't know what to do with it"
      end
      true
    end
  end

  def hangman
    game = GameInstance.new
    stick = game.stick
    word = get_word.split("")
    p word
    # display words accourding to the word length
    word.each{ |char| stick += "_" }
    puts stick
    incorrect_chars = []
    count = 0
    #every turn allow the player to make a guess of letter
    11.times do
      # get user input and update the stick
      #if the word include the selcted char display it on the stick, if it is not display incorrect words
      input = get_input()
      update_stick(input, word, @stick, incorrect_chars)
      puts stick
      puts "incorrect letters so far: #{incorrect_chars.join(" ")} " if incorrect_chars.size > 0
      if stick == word.join("")
        puts "you win"
        return
      end
    end
    puts "you lose"
  end
end
Game.new.start
