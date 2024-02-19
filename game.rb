require "yaml"

class Word

  attr_accessor :word, :player_word, :incorrect_chars, :remaining_tries

  def initialize
    @word = word_from_file
    @player_word = ''
    @incorrect_chars = []
    @remaining_tries = 12
    output_player_word
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

  def output_player_word
    selcted_word = @word.split('')
    # display words accourding to the word length
    selcted_word.each { |_char| @player_word += '_' }
  end

  def update_player_word( input, word, player_word, incorrect_chars)
    if word.include?(input)
      word.split('').each_with_index do |char, index|
        player_word[index] = input if char == input
      end
    else
      incorrect_chars << input unless incorrect_chars.include?(input)
    end
  end

  # what will be saved in yaml file

  def to_yaml
    YAML.dump({
      word: @word,
      current_word: @player_word,
      incorrect_chars: @incorrect_chars,
      remaining_tries: @remaining_tries
    })
  end
end

class Game

  attr_accessor :word

  def initialize
    @word = ''
  end

  def input_from_user
    puts 'Enter yout character , 1 to save or 0 for main menu : '
    input = gets.chomp
    if input == '1'
      # if user select save the current user can save the current game
      File.open("save/#{@word.object_id}.yaml", 'w') {|f| f.write @word.to_yaml}
      puts 'game saved successfuly!'
      return input_from_user
    elsif input == '0'
      return start
    end
     input.downcase
  end

  def start
    while true
      puts "1 to start "
      puts "2 to load saved games "
      print '3 to exit: '
      input = gets.chomp
      case input
      when '1'
        @word = Word.new
        hangman
      when '2'
        # get all the yaml file under saved dir
        saved_games = Dir["save/*.yaml"]
        saved_games.each_with_index do |game, index|
          file_data = YAML.load_file(game)
          puts "#{index + 1} #{file_data[:current_word]} "
        end
        print "press the number of the game you want to load or 0 to go back: "
        input = gets.chomp
        if input == '0'
          return start
        elsif saved_games.each_with_index { |_game, index|input == "#{index + 1}"}
          # this will load the file based on the given input and set attributes directly to the new word class
          game = YAML.load_file(saved_games[input.to_i - 1])
          @word = Word.new
          @word.word = game[:word]
          @word.player_word = game[:current_word]
          @word.incorrect_chars = game[:incorrect_chars]
          @word.remaining_tries = game[:remaining_tries]
          hangman
        else
          puts "invalid input"
          return start
        end
      when '3'
        return false
      else
        puts "You gave me #{input} i don't know what to do with it"
      end
      true
    end
  end

  def hangman

    puts @word.player_word
    # every turn allow the player to make a guess of letter
    until word.remaining_tries == 0 do
      input = input_from_user
      @word.update_player_word(input, @word.word, @word.player_word, @word.incorrect_chars)
      puts word.player_word
      puts "incorrect letters so far: #{@word.incorrect_chars.join('')} " if @word.incorrect_chars.size > 0
      word.remaining_tries -= 1
      if @word.word == @word.player_word
        puts 'You win'
        return
      end
    end
    puts 'you lose'
  end
end

Game.new.start
