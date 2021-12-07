def stock_picker(stocks)
  profit = -1
  days = []
  stocks.each_with_index do |buy, i|
    (i...stocks.length).each do |j|
      current_profit = stocks[j] - buy
      if profit < current_profit
        profit = current_profit
        days = [i, j]
      end
    end
  end
  days
end

p stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])
