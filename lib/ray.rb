require "matrix"

class Vector
  def hit_sphere(radius, ray)

    oc = ray.origin - self
    a = ray.direction.dot(ray.direction)
    b = 2.0 * (oc.dot(ray.direction))
    c = oc.dot(oc) - radius * radius
    discriminant = b * b - 4 * a * c

    if discriminant < 0
      -1.0
    else
      (-b - Math.sqrt(discriminant)) / (2 * a)
    end
  end

  def x
    self[0]
  end

  def y
    self[1]
  end

  def z
    self[2]
  end

  def vector_product_magic(v)
    Vector[self[0] * v[0], self[1] * v[1], self[2] * v[2]]
  end
end


class Ray
  def initialize(origin, direction)
    @a = origin
    @b = direction
  end

  def origin
    @a
  end

  def self.random_in_unit_sphere
    random = Random.new

    p = nil
    loop do
      p = 2.0 * Vector[random.rand(1.0), random.rand(1.0), random.rand(1.0)] - Vector[1, 1, 1]
      len = p.dot(p)
      break if len < 1.0
    end

    return p

  end

  def color(world, depth)
    rec, did_hit = world.hit(self, 0.001, 4000000000)

    if did_hit

      if depth < 50

        scattered, scattered_ray, attenuation = rec.material.scatter(self, rec)
        if scattered
          return attenuation.vector_product_magic scattered_ray.color(world, depth + 1)
        else
          return Vector[0.0, 0.0, 0.0]
        end

      else
        return Vector[0.0, 0.0, 0.0]
      end

    end

    unit_direction = self.direction.normalize
    t = 0.5 * (unit_direction.y + 1)
    return (1.0 - t) * Vector[1.0, 1.0, 1.0] + t * Vector[0.5, 0.7, 1.0]
  end

  def direction
    @b
  end

  def point_at_parameter(t)
    @a + (t * @b)
  end

end


class HitRecord
  attr_accessor :t, :p, :normal, :material

  def initialize(t, p, normal, material)
    @t = t
    @p = p
    @normal = normal
    @material = material
  end
end

class Hitable
  def hit(ray, t_min, t_max)
    return rec, false
  end
end

class Sphere < Hitable

  def initialize(center, radius, material)
    @center = center
    @radius = radius
    @material = material
  end

  def hit(ray, t_min, t_max)
    oc = ray.origin - @center
    a = ray.direction.dot(ray.direction)
    b = oc.dot(ray.direction)
    c = oc.dot(oc) - @radius * @radius
    discriminant = b * b - a * c

    if discriminant > 0
      temp = (-b - Math.sqrt(discriminant)) / a

      if temp < t_max && temp > t_min
        p = ray.point_at_parameter(temp)
        normal = (p - @center) / @radius
        hit_record = HitRecord.new(temp, p, normal, @material)
        return hit_record, true
      end
      temp = (-b + Math.sqrt(discriminant)) / a
      if temp < t_max && temp > t_min
        p = ray.point_at_parameter(temp)
        normal = (p - @center) / @radius
        hit_record = HitRecord.new(temp, p, normal, @material)
        return hit_record, true
      end
    end

    return nil, false

  end
end


class HitableList < Hitable

  def initialize(list)
    @list = list
  end

  def hit(ray, t_min, t_max)
    hit_anyting = false

    closest_so_far = t_max
    rec = nil
    @list.each do |obj|
      hit_result, did_hit = obj.hit(ray, t_min, closest_so_far)
      if did_hit
        hit_anyting = true
        closest_so_far = hit_result.t
        rec = hit_result
      end

    end
    return rec, hit_anyting
  end
end