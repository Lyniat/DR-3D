class Triangle
  def initialize args, cam, v0, v1, v2, texture
    @args = args
    @cam = cam
    @v0 = Vec4.new(v0.x,v0.y,v0.z,1)
    @v1 = Vec4.new(v1.x,v1.y,v1.z,1)
    @v2 = Vec4.new(v2.x,v2.y,v2.z,1)
    @texture = texture
  end

  def normal
    edge_0 = @v1 - @v0
    edge_1 = @v2 - @v0
    Vec3.new.cross_from!(edge_0,edge_1).normalize!
  end

  def mid
    (@v0 + @v1 + @v2)/Vec4.new(3,3,3,3)
  end

  def draw
    _v0 = @cam.project(@v0)
    _v1 = @cam.project(@v1)
    _v2 = @cam.project(@v2)

    if _v0.z < 0 || _v1.z < 0 || _v2.z < 0
      return
    end

    c = Vec3.new(@cam.x,@cam.y,@cam.z)
    cross = c.dot(normal)

    if(cross < 0)
      return
    end

    return {
      x: _v0.x,
      y: _v0.y,
      x2: _v1.x,
      y2: _v1.y,
      x3: _v2.x,
      y3: _v2.y,
      path: "sprites/#{@texture}.png",
      source_x:  0,
      source_y:  0,
      source_x2: 0,
      source_y2: 0,
      source_x3: 0,
      source_y3: 0}
  end
end
