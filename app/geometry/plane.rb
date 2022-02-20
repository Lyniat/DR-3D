class Plane
  def initialize args, cam, x,y,z,size
    @cam = cam
    @x = x
    @y = y
    @z = z
    @triangles = []

    _x = @x - size/2
    _y = @y - size/2
    _z = @z

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y + size, _z + size),Vec3.new(_x, _y, _z + size),Vec3.new(_x + size, _y, _z + size),"rd")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x + size, _y + 1, _z + size),Vec3.new(_x, _y + size, _z + size),Vec3.new(_x + size, _y, _z + size),"rd")
  end

  def draw
    i = 0
    while i < @triangles.size
      @triangles[i].draw
      i += 1
    end
  end

end
