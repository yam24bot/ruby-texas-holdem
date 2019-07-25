FACES = "AKQJT98765432"
SUITS = "HDCS"


#build deck
deck = []
    FACES.each_byte do |f|
        SUITS.each_byte do |s|
            deck.push(f.chr + s.chr)
        end
    end

# shuffle deck
3.times do
  shuf = []
  deck.each do |c|
    loc = rand(shuf.size + 1)
    shuf.insert(loc, c)
  end
  deck = shuf.reverse
  puts deck.to_s + '\n'
end

