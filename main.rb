require "matrix"
require "./lib/ray"
require "./lib/camera"
require './lib/material'
nx = 400
ny = 200
ns = 40

render_start_time = Time.new

rng = Random.new(1234)
path_to_file = "out.ppm"
File.delete(path_to_file) if File.exist?(path_to_file)
file = File.new("out.ppm", "wb")
file.puts "P3\n #{nx} #{ny} \n255"


camera = Camera.new()

s1 = Sphere.new(Vector[0, 0, -1], 0.5, Metal.new(Vector[0.8, 0.8, 0.8], 0.3))
s2 = Sphere.new(Vector[0, -100.5, -1], 100, Lambertian.new(Vector[0.8, 0.8, 0.00]))
world = HitableList.new([s1, s2])

for j in (ny - 1).downto 0
  for i in 0..(nx - 1)

    col = Vector[0, 0, 0]

    for s in 0..(ns - 1)

      u = (i.to_f + rng.rand(1.0)) / nx.to_f
      v = (j.to_f + rng.rand(1.0)) / ny.to_f
      r = camera.get_ray(u, v)
      col = col + r.color(world, 0)
    end


    vec = col / ns.to_f
    vec = Vector[Math.sqrt(vec[0]), Math.sqrt(vec[1]), Math.sqrt(vec[2])]
    ir = 255.99 * vec[0]
    ig = 255.99 * vec[1]
    ib = 255.99 * vec[2]

    percent = ((ny - j) * nx + i).to_f / (ny * nx).to_f * 100
    print "%#{percent} \r"
    file.puts "#{ir.to_i} #{ig.to_i} #{ib.to_i} "
  end
end

render_end_time = Time.new

render_time = render_end_time - render_start_time

puts "Render finished in #{render_time} seconds"
# 9.622005
# 9.522214


