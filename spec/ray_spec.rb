require 'rspec'
require 'spec_helper'

require "matrix"
require 'ray'

describe 'Ray' do

  it 'should calculate point at parameter correctly' do

    a = Vector.zero(3)
    b = Vector[1.0, 0.0, 0.0]
    ray = Ray.new(a, b)
    point = ray.point_at_parameter(3)

    expect(point[0]).to eq 3
  end

  it 'should give a random vector in unit sphere' do
    r = Ray.random_in_unit_sphere

    puts r
  end
end

