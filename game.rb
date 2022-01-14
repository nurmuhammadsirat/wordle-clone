class Wordle
  attr_reader :words, :answer

  def initialize(words = nil, num = 5)
    @words = words || load_default
    @num = num
    @answer = @words.select {|w| w.length == @num}.sample
  end

  def compare(guess)
    (0...@num).map do |num|
      if guess[num] == @answer[num]
        2
      elsif guess[num] != @answer[num] && @answer.chars.include?(guess[num])
        1
      else
        0
      end
    end
  end

  private

  def load_default
    File.read('./data/words.txt').split("\n")
  end
end

class Game
  def initialize
    puts "Initializing game!"
    @wordle = Wordle.new
    puts "The answer is #{@wordle.answer}"

    puts "You get 10 guesses!"

    @max_guesses = 10
    @guesses = []
  end

  def play
    win = false

    while true
      system('clear')
      if @guesses.length > 0
        @guesses.each do |guess, clue|
          puts guess.chars.join(' ')
          puts clue.join(' ')
          puts
        end
      end

      puts "You have #{@max_guesses - @guesses.length} guesses left!"
      print 'Guess the word: '
      guess = gets
      clue = @wordle.compare(guess)
      @guesses << [guess, clue]

      if clue.all?(2)
        win = true
        break
      end

      puts @max_guesses - @guesses.length
      if (@max_guesses - @guesses.length) == 0
        break
      end
    end

    if win
      puts "Congrats! The word is #{@guesses.last[0]}"
    else
      puts "Thanks for playing! The answer is #{@wordle.answer}"
    end
  end
end

Game.new.play

