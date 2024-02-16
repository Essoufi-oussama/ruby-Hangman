puts "Game started!"

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

def start
  word = get_word.split("")
  p word
  # display words accourding to the word length
  stick = ""
  word.each{ |char| stick += "_" }
  puts stick
  incorrect_chars = []
  #every turn allow the player to make a guess of letter
  11.times do
    # get user input and update the stick
    #if the word include the selcted char display it on the stick, if it is not display incorrect words
    print "Enter character: "
    input = gets.chomp
    update_stick(input, word, stick, incorrect_chars)
    puts stick
    puts "incorrect letters so far: #{incorrect_chars.join(" ")} " if incorrect_chars.size > 0
    if stick == word.join("")
      puts "you win"
      return
    end
  end
  puts "you lose"
end

start
