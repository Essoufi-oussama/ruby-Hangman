require "yaml"

class Word
  attr_accessor :word, :player_word, :incorrect_chars
  def initialize
    @word = word_from_file
    @player_word = ''
    @incorrect_chars = []
  end


  def word_from_file
    # Load the words from the txt file
    file = File.open("words.txt")
    words = file.readlines.map(&:chomp)
    # select random word between 5 and 12 chracters
    filtered_words = words.select {|word| word.size > 4 && word.size < 13}
    word = filtered_words.sample
    file.close
    word
  end

  def update_player_word( input, word, player_word, incorrect_chars)
    if word.include?(input)
      word.each_with_index do |char, index|
        player_word[index] = input if char == input
      end
    else
      incorrect_chars << input unless incorrect_chars.include?(input)
    end
  end

  def to_yaml
    YAML.dump({
      word: @word,
      current_word: @player_word,
      incorrect_chars: @incorrect_chars
    })
  end

end



class Game

  attr_accessor :word

  def initialize
    @word = ''
  end

  def input_from_user
    print 'Enter character or 1 to save: '
    input = gets.chomp
    if input == '1'
      # if user select save the current user can save the current game
      File.open('saved.yaml', 'w') {|f| f.write @word.to_yaml}
      puts 'game saved successfuly!'
      return input_from_user
    end
     input.downcase
  end

  def start
    while true
      puts ' Press 1 to start'
      puts ' Press 2 to load saved games '
      puts ' Press 3 to exit'
      input = gets.chomp
      case input
      when '1'
        hangman
      when '2'
        # display saved games
      when '3'
        return false
      else
        puts "You gave me #{input} i don't know what to do with it"
      end
      true
    end

  end

  def hangman
    @word = Word.new
    selcted_word = @word.word.split("")
    # display words accourding to the word length
    selcted_word.each { |_char| @word.player_word += '_' }
    puts @word.word
    # every turn allow the player to make a guess of letter
    11.times do
      # get user input and update the player_word
      # if the word include the selcted char display it on the player_word, if it is not display incorrect words
      input = input_from_user
      @word.update_player_word(input, selcted_word, @word.player_word, @word.incorrect_chars)
      puts word.player_word
      puts "incorrect letters so far: #{@word.incorrect_chars.join('')} " if @word.incorrect_chars.size > 0
      if @word.player_word == selcted_word.join('')
        puts 'You win'
        return
      end
    end
    puts 'you lose'
  end
end

Game.new.start
