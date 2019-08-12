class Camera

  def initialize
    @lower_left_corner = Vector[-2.0, -1.0, -1.0]
    @horizontal = Vector[4.0, 0.0, 0.0]
    @vertical = Vector[0.0, 2.0, 0.0]
    @origin = Vector[0.0, 0.0, 0.0]
  end

  def get_ray(qu, qv)
    qvv = (qv * @vertical)
    quh = qu * @horizontal
    Ray.new(@origin, @lower_left_corner + (quh) + qvv)
  end
end
