class GameOfLife
    attr_reader :grid

    def initialize(rows, columns)
        @rows = rows
        @columns = columns
        @grid = Array.new(rows) {Array.new(columns,
GameOfLifeStateMachine::DEAD_CELL)}
    end

    # State is an array of arrays containing points to make alive
    def set_initial_state(state)
        state.each {|a,b| @grid[a][b]=GameOfLifeStateMachine::LIVING_CELL}
    end
    
    def randomize
      #0.times{rand_seed}
      
#~       for i in (rand(20))..(rand(20) + 20)
#~          for j in (rand(40) + 50)..rand(99) + 100
#~           @grid[i][j] = 1 if rand < 0.42
#~         end
#~       end
#~       
      for i in 0..198
        for j in 0..198
          @grid[i][j] = 1 if rand < 0.1
        end
      end
      
      for i in 0..198
        for j in 0..198
          @grid[i][j] = 1 if rand < 0.05
        end
      end
      
      
#~       
    end
    
    def rand_seed
      for i in (rand(40) + 50)..rand(99) + 70
        for j in (rand(40) + 50)..rand(99) + 70
          @grid[i][j] = 1 if rand < 0.42
        end
      end
      
      
      
    end

    def next_state
        new_grid = []
        #t = Time.now
        @grid.each_with_index do |row, i|
            new_row = []
            row.each_with_index do |column, j|
                new_row <<
GameOfLifeStateMachine.next_state(@grid[i][j], alive_neighbours(i,j))
            end
            new_grid << new_row
        end
        @grid = new_grid
        #puts Time.now - t
    end

    def alive_neighbours(row, column)
        count = 0
        (-1..1).each do |i|
            (-1..1).each do |j|
                next if (i.zero? and j.zero?)
                row_index = row + i
                col_index = column + j
                if row_index >= 0 and row_index < @rows and col_index>= 0 and col_index < @columns
                    count += 1 if @grid[row_index][col_index] == GameOfLifeStateMachine::LIVING_CELL
                end
            end
        end
        count
    end


    def to_s
        s = ""
        @grid.each {|row| row.each {|col| s << col.to_s << " "}; s <<
"\n"}
        s
    end
end