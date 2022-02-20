class Camera
  attr_accessor :x, :y, :z
  def initialize angle, near, far, x = 0, y = 0, z = 0
    @x = x
    @y = y
    @z = z
    @aspect_ratio = Constants::WIDTH / Constants::HEIGHT
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
    n.x = ((n.x * Constants::WIDTH) / (2.0 * n.w) + Constants::WIDTH/2)
    n.y = ((n.y * Constants::HEIGHT) / (2.0 * n.w) + Constants::HEIGHT/2)
    n
  end

end
