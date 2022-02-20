require '/app/include.rb'

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
    args.outputs.sprites << triangles[i][:data].draw
    i += 1
  end
end
