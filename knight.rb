class Knight
    attr_accessor :moves, :children
    attr_reader :position
    def initialize(pos)
        @position = pos
        @moves = valid_moves()
        @children = []
    end

    def valid_moves()
        moves = []
        possible_moves = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
        possible_moves.each do |move|
            temp = [move[0] + position[0], move[1] + position[1]]
            next if temp.any? {|cord| cord < 0 || cord > 7}
            moves.push(temp)
        end
        self.moves = moves
    end
end

class Board
    attr_reader :alpha
    def createChild(curr)
        curr.moves.each do |move|
            child = find_child(move).nil? ? Knight.new(move) : find_child(move)
            curr.children << child
        end

        
    end
    def create_tree(destination, queue = [alpha], index = 0)
        curr = queue[index]

        createChild(curr)
        curr.children.each do |child|
            queue << child unless queue.include?(child)
            return if child.position == destination
        end

        index += 1
        create_tree(destination, queue, index)

    end
    def find_child(pos, queue = [alpha], index = 0)
        curr = queue[index]
        return curr if curr.nil?
        curr.children.each do |child|
            if child.position == pos
                return child
            end
            queue << child unless queue.include?(child)
        end

        index += 1
        find_child(pos, queue, index)
    end

    def find_parent(destination, queue = [alpha], index = 0)
        curr = queue[index]
        curr.children.each do |child|

            if child.position == destination
                return curr
            end
            queue << child unless queue.include?(child)
        end
        index += 1
        find_parent(destination, queue, index)
    end

    def find_path(destination, path = [destination])
        until path[0] == alpha.position do
            path = path.unshift(find_parent(path[0]).position)
        end
        return path
    end

    def knight_move(start, destination)
        @alpha = Knight.new(start)
        create_tree(destination)
        path = find_path(destination)
        puts "You made it in #{path.size - 1} moves! Here's your path:"
        path.each_with_index { |move, index| puts "#{index}: #{move}" }
    end

end

a = Board.new()
a.knight_move([3, 3], [4, 3])
