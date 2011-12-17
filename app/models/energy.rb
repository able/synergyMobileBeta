class Energy 
  include Mongoid::Document

  field :timestamp
  field :average_power
  field :max_power
  field :min_power
  field :cumulative_energy
  field :apparent_power

  belongs_to :entity 
  attr_accessible :timestamp, :value, :entity
end


