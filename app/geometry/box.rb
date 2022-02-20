class Box
  def initialize args, cam, x,y,z
    @cam = cam
    @x = x
    @y = y
    @z = z
    @triangles = []

    _x = @x - 0.5
    _y = @y - 0.5
    _z = @z - 0.5

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y, _z),Vec3.new(_x, _y + 1, _z),Vec3.new(_x + 1, _y, _z),"rd")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y + 1, _z),Vec3.new(_x + 1, _y + 1, _z),Vec3.new(_x + 1, _y, _z),"rd")

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y, _z + 1),Vec3.new(_x, _y, _z),Vec3.new(_x, _y + 1, _z),"g")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y + 1, _z + 1),Vec3.new(_x, _y, _z + 1),Vec3.new(_x, _y + 1, _z),"g")

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y, _z),Vec3.new(_x, _y, _z + 1),Vec3.new(_x + 1, _y, _z),"b")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y, _z + 1),Vec3.new(_x + 1, _y, _z + 1),Vec3.new(_x + 1, _y, _z),"b")

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y + 1, _z + 1),Vec3.new(_x, _y, _z + 1),Vec3.new(_x + 1, _y, _z + 1),"r")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x + 1, _y + 1, _z + 1),Vec3.new(_x, _y + 1, _z + 1),Vec3.new(_x + 1, _y, _z + 1),"r")

    @triangles << Triangle.new(args,@cam,Vec3.new(_x + 1, _y, _z),Vec3.new(_x + 1, _y, _z + 1),Vec3.new(_x + 1, _y + 1, _z),"gd")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x + 1, _y, _z + 1),Vec3.new(_x + 1, _y + 1, _z + 1),Vec3.new(_x + 1, _y + 1, _z),"gd")

    @triangles << Triangle.new(args,@cam,Vec3.new(_x, _y + 1, _z + 1),Vec3.new(_x, _y + 1, _z),Vec3.new(_x + 1, _y + 1, _z),"bd")
    @triangles << Triangle.new(args,@cam,Vec3.new(_x + 1, _y + 1, _z + 1),Vec3.new(_x, _y + 1, _z + 1),Vec3.new(_x + 1, _y + 1, _z),"bd")
  end

  def draw
    return @triangles
    i = 0
    while i < @triangles.size
      @triangles[i].draw
      i += 1
    end
  end

end
