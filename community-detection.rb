#from http://www.informit.com/articles/article.aspx?p=26943&seqNum=6


file = File.new(file_name, "r")
while (line = file.gets)
	if line[0].chr!="#"
		test.edges =  line.split("\t")
	end
end
file.close



class LowerMatrix < TriMatrix

  def initialize
    @store = ZArray.new
  end

end


class Graph

  def initialize(*edges)
    @store = LowerMatrix.new
    @max = 0
    for e in edges
      e[0], e[1] = e[1], e[0] if e[1] > e[0]
      @store[e[0],e[1]] = 1
      @max = [@max, e[0], e[1]].max
    end
  end

  def [](x,y)
    if x > y
     @store[x,y]
    elsif x < y
     @store[y,x]
    else
     0
    end
  end

  def []=(x,y,v)
    if x > y
     @store[x,y]=v
    elsif x < y
     @store[y,x]=v
    else
     0
    end
  end

  def edge? x,y
    x,y = y,x if x < y
    @store[x,y]==1
  end

  def add x,y
    @store[x,y] = 1
  end

  def remove x,y
    x,y = y,x if x < y
    @store[x,y] = 0
    if (degree @max) == 0
     @max -= 1
    end
  end

  def vmax
    @max
  end

  def degree x
    sum = 0
    0.upto @max do |i|
     sum += self[x,i]
    end
    sum
  end

  def each_vertex
    (0..@max).each {|v| yield v}
  end

  def each_edge
    for v0 in 0..@max
     for v1 in 0..v0-1
      yield v0,v1 if self[v0,v1]==1
     end
    end
  end

end


  mygraph = Graph.new([1,0],[0,3],[2,1],[3,1],[3,2])

  # Print the degrees of all the vertices: 2 3 3 2
  mygraph.each_vertex {|v| puts mygraph.degree(v)}

  # Print the list of edges
  mygraph.each_edge do |a,b|
   puts "(#{a},#{b})"
  end

  # Remove a single edge
  mygraph.remove 1,3

  # Print the degrees of all the vertices: 2 2 2 2