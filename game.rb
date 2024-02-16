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

# display words accourding to the word length

word = get_word.split("")
p word
stick = ""
word.each{ |char| stick += "_" }
puts stick
# get user input and update the stick
input = gets.chomp
#if the word include the selcted char display it on the stick
word.each_with_index do |char, index|
  stick[index] = input if char == input
end
