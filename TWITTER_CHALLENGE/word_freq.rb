require_relative 'stopwords'
require_relative 'twitter_setup'

class WordCount

  def wordify(status)
    status.downcase.scan(/\w+/).select { 
      |word| 
      !(STOPWORDS.include? word) &&
       word.length != 1
      }
  end

  def populate
    stop, current, words = Time.now + 300, Time.now, []
    while current < stop
      TweetStream::Client.new.sample do |tweet|
        words << wordify(tweet.text)
        current = Time.now
        break if stop < current 
      end
    end
    return words.flatten
  end

  def freq_count
    hash = Hash.new(0)
    populate.each { |word| hash[word] += 1 }
    hash.sort_by{ |k,v| v }.reverse.take(10)
  end

end

p WordCount.new.freq_count
