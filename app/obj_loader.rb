class ObjLoader
  def initialize args, path, cam
    content = args.gtk.read_file path
    lines = content.split("\n")
    v = []
    tex = []
    @vt = []

    i = 0
    while i < lines.size
      l = lines[i]
      if l[0] == 'v' && l[1] == ' '
        l = l.gsub("v ", "")
        vertices = l.split(' ')
        vector = Vec3.new(vertices[0].to_f / 1, vertices[1].to_f / 1, vertices[2].to_f / 1)
        v << vector
        # puts vector.to_a
      end
      i += 1
    end
    puts v.size
    i = 0
    while i < lines.size
      l = lines[i]
      if l[0] == 'v' && l[1] == 't'
        l = l.gsub("vt", "")
        textures = l.split(' ')
        vector = Vec2.new(textures[0].to_f, textures[1].to_f)
        tex << vector
        # puts vector.to_a
      end
      i += 1
    end

    i = 0
    while i < lines.size
      l = lines[i]
      if l[0] == 'f' && l[1] == ' '
        l = l.gsub("f ", "")
        ff = l.split(' ')
        puts ff
        k = 0
        xyz = []
        xyz_t = []
        while k < ff.size
          stuff = ff[k].split("/")
          puts stuff
          xyz << v[stuff[0].to_i - 1]
          xyz_t << tex[stuff[1].to_i - 1]
          # puts xyz
          k += 1
        end
        tr = Triangle.new(args,cam,xyz[0],xyz[1],xyz[2],"r",xyz_t[0],xyz_t[1],xyz_t[2])
        @vt << tr
      end
      i += 1
    end
  end

  def get
    @vt
  end
end
