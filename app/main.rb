require '/app/libs/vectormath.rb'

WIDTH = 1280
HEIGHT = 720

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

class Camera
  attr_accessor :x, :y, :z
  def initialize angle, near, far, x = 0, y = 0, z = 0
    @x = x
    @y = y
    @z = z
    @aspect_ratio = WIDTH / HEIGHT
    @fov = 1.0 / Math.tan(angle/2.0)
    @v_up = Vec3.new(0,1,0)
    @m_p = Mat4x4.new(@fov * @aspect_ratio,0,0,0,
                      0,@fov,0,0,
                      0,0,(far+near)/(far-near),1,
                      0,0,(2*near*far)/(near-far),0)
  end

  def view tx, ty, tz
    z_axis = Vec3.new(@x-tx,@y-ty,@z-tz).normalize!
    x_axis = Vec3.new.cross_from!(Vec3.new(0,1,0), z_axis).normalize!
    y_axis = Vec3.new.cross_from!(z_axis,x_axis)

    eye = Vec3.new(tx,ty,tz)

    view = Mat4x4.new(x_axis.x,y_axis.x,z_axis.x,0,
                      x_axis.y,y_axis.y,z_axis.y,0,
                      -x_axis.dot(eye),-y_axis.dot(eye),-z_axis.dot(eye),1)
    view
  end

  def project vec4
    m_v = view(0,0,0)
    vp = Mat4x4.new.mul_from!(@m_p,m_v)
    #puts vp.to_a
    n = Vec4.new.mul_mat_from!(vec4, vp)
    n.x = ((n.x * WIDTH) / (2.0 * n.w) + WIDTH/2)
    n.y = ((n.y * HEIGHT) / (2.0 * n.w) + HEIGHT/2)
    n
  end

end

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

def init args
  @cam = Camera.new(60,1,1000,50,50,50)
  @boxes = []

  @boxes << Box.new(args,@cam,0,0,0)
  @boxes << Box.new(args,@cam,2,0,0)
  @boxes << Box.new(args,@cam,0,0,2)
  @boxes << Box.new(args,@cam,2,0,2)

  @boxes << Box.new(args,@cam,0,2,0)
  @boxes << Box.new(args,@cam,2,2,0)
  @boxes << Box.new(args,@cam,0,2,2)
  @boxes << Box.new(args,@cam,2,2,2)

end

def tick args
  radius = 200
  speed = 0.01
  init(args) if args.state.tick_count == 0

  @cam.x = Math.sin(args.state.tick_count * speed) * radius
  @cam.y = Math.cos(args.state.tick_count * speed) * radius
  #@ground.draw

  sprites = []
  i = 0
  while i < @boxes.size
    sprites << @boxes[i].draw
    i += 1
  end


  triangles = []

  # get all
  i = 0
  while i < sprites.size
    k = 0
    while k < sprites[i].size
      triangles << {data: sprites[i][k],
                    dist: Vec3.new(@cam.x,@cam.y,@cam.z).sub!(sprites[i][k].mid).length
      }
      k += 1
    end
    i += 1
  end

  # sort
  triangles = triangles.sort_by { |k| k[:dist]}

  # draw
  i = 0
  while i < triangles.size
    puts triangles[i][:dist]
    args.outputs.sprites << triangles[i][:data].draw
    i += 1
  end
end
