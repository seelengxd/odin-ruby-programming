def on_the_board(i, j)
  (0..7).include?(i) && (0..7).include?(j)
end

STEPS = [[-2, -1], [-1, -2], [1, 2], [2, -1], [2, 1], [1, -2], [-1, 2], [-2, 1]].freeze

def knight_moves(start, goal)
  start = [start[0], start[1]]
  goal = [goal[0], goal[1]]
  queue = [[start, 'START']]
  visited = Array.new(8) { Array.new(8) }
  while queue.length.positive?
    curr, prev = queue.shift
    if prev == 'START' || visited[curr[0]][curr[1]].nil?
      visited[curr[0]][curr[1]] = prev
      STEPS.each do |step|
        x = curr[0] + step[0]
        y = curr[1] + step[1]
        queue << [[x, y], curr] if on_the_board(x, y)
      end
    end

    break if curr == goal
  end
  res = []
  curr = goal
  until curr == 'START'
    res.unshift(curr)
    curr = visited[curr[0]][curr[1]]
  end
  puts "=> You made it in #{res.length} moves!  Here's your path:"
  res.each { |coords| p coords }
end

knight_moves([0, 0], [1, 2])
knight_moves([0, 0], [3, 3])
knight_moves([3, 3], [0, 0])
