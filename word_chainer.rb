require 'set'

class WordChainer
    attr_reader :dictionary

    def initialize(dictionary_file_name) # initializing the dictionary instance variable
        @dictionary = File.readlines(dictionary_file_name).map(&:chomp) # opening the dictionary file and chomping each line or word rather
        @dictionary = Set.new(@dictionary) # saving the lines or words to the Set
    end

    def run(source, target)
        @current_words = [source]
        @all_seen_words = { source => nil }

        until @current_words.empty? || @all_seen_words.include?(target)
            explore_current_words
        end

        build_path(target)
    end

    def explore_current_words
        new_current_words = []
        @current_words.each do |current_word|
            adjacent_words(current_word).each do |adjacent_word|
                next if @all_seen_words.key?(adjacent_word)

                new_current_words << adjacent_word
                @all_seen_words[adjacent_word] = current_word
            end
        end

        @current_words = new_current_words
    end

    def build_path(target)
        path = []
        current_word = target
        until current_word.nil?
            path << current_word
            current_word = @all_seen_words[current_word]
        end

        path.reverse
    end



    def adjacent_words(word) # method or finding letter that are off by one letter
        adjacent_words = [] # initializing an array variable to store the new words

        word.each_char.with_index do |old_letter, i| # starting a loop for grabbing each letter and the index from the original word
            ('a'..'z').each do |new_letter| # starting to loop through the entire alphabet
                next if old_letter == new_letter # if the old_letter and the new_letter are the skip to the next letter
                new_word = word.dup # set a new_word to dup of the original word this way we can change one letter at a time
                new_word[i] = new_letter # changing the word[i] to new_letter

                adjacent_words << new_word if dictionary.include?(new_word) # if the new_word is a real word add it to the adjacent words
            end
        end

        adjacent_words # return the array of adjacent words
    end
end

if $PROGRAM_NAME == __FILE__
      p WordChainer.new(ARGV.shift).run("duck", "ruby")
end

