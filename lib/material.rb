require 'matrix'
class Material

  def scatter (ray, rec)
    scattered_ray = nil # ray
    attenuation = nil # vector
    return false, scattered_ray, attenuation
  end
end


class Vector

  def reflect(normal)
    self - ((2 * self.dot(normal)) * normal)
  end
end


class Lambertian < Material
  def scatter(ray, rec)
    # reflect(unit_vector(ray.direction()), rec.normal)

    target = rec.p + rec.normal + Ray.random_in_unit_sphere
    scattered = Ray.new(rec.p, target - rec.p)
    is_scattered = true
    return is_scattered, scattered, @albedo
  end

  def initialize(albedo)
    @albedo = albedo
  end

end


class Metal < Material


  def scatter(ray, rec)
    # reflect(unit_vector(ray.direction()), rec.normal)

    unit = ray.direction.normalize

    reflected = unit.reflect(rec.normal)
    scattered = Ray.new(rec.p, reflected + @fuzz * Ray.random_in_unit_sphere)
    dot_product = scattered.direction.dot(rec.normal)
    is_scattered = dot_product > 0
    return is_scattered, scattered, @albedo
  end

  def initialize(albedo, fuzz)
    @albedo = albedo
    @fuzz = fuzz
  end
end