SUITS = %w(c d h s)
FACES = %w(A K Q J T 9 8 7 6 5 4 3 2)

RANKS = {
    :royal_flush     => 'Royal Flush',
    :straight_flush  => 'Straight Flush',
    :four_of_a_kind  => 'Four of a Kind',
    :full_house      => 'Full House',
    :flush           => 'Flush',
    :straight        => 'Straight',
    :three_of_a_kind => 'Three of a Kind',
    :two_pair        => 'Two Pair',
    :pair            => 'Pair',
    :high_card       => 'High Card',
    :fold            => ''
}

class Hand
  def initialize(line)

    @cards = line.split

    @faces = Hash.new { [] }
    @suits = Hash.new { [] }
    @count = Hash.new { [] }

    @cards.each do |card|
      f = FACES.index(card[0].chr)
      s = SUITS.index(card[1].chr)
      @faces[f] = @faces[f] << s
      @suits[s] = @suits[s] << f
    end

    @faces.keys.each do |face|
      n = @faces[face].size
      @count[n] = @count[n] << face
    end

    @rank = rank_hand
  end

  def rank_hand
    return :fold if @cards.size < 7

    return :royal_flush if @suits.keys.any? do |suit|
      (0..5).all? do |face|
        @suits[suit].include? face
      end
    end

    return :straight_flush if @suits.keys.any? do |suit|
      high = @suits[suit].min
      (high..high + 5).all? do |face|
        @suits[suit].include? face
      end
    end

    return :four_of_a_kind if not @count[4].empty?

    return :full_house if @count[3].size == 2 or (@count[3].size == 1 and not @count[2].empty?)

    return :flush if @suits.keys.any? do |suit|
      @suits[suit].size >= 5
    end

    return :straight if @faces.keys.any? do |high|
      (high..high + 5).all? do |face|
        @faces.keys.include? face
      end
    end

    return :three_of_a_kind if @count[3].size == 1

    return :two_pair if @count[2].size >= 2

    return :pair if @count[2].size == 1

    :high_card
  end

  attr_reader :cards, :rank
end


def main
  deck = []
  FACES.each do |f|
    SUITS.each do |s|
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
  end

# deal common cards
  common = Array.new(5) { deck.pop }
  puts "#{common.join(' ')} - common cards on the table "

# deal player's hole cards
  hole = Array.new(1) { Array.new(2) { deck.pop } }

  puts  "#{hole.join(' ')} - Player`s cards "


# output hands
  hands = []
  all_fold = true
  while all_fold do
    hands = []
    hole.each do |h|
      num_common = [0, 3, 4, 5][rand(4)]
      if num_common == 5
        all_fold = false
      end
      if num_common > 0
        hand = h + common[0 ... num_common]
      else
        hand = h
      end
      hands.push(hand.join(' '))
    end
  end

  hands = hands.collect { |l| Hand.new(l.chomp) }
  # puts hands.cards

  hands.each do |h|
    puts "#{h.cards.join(' ')}  #{RANKS[h.rank]}"
  end
end

main
