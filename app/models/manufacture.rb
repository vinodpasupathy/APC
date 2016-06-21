class Manufacture
  include Mongoid::Document
  field :manu_name
  field :manu_logo
  field :taxon_id
  index({ manu_name: 1},{ background: true })
  index({ id: 1},{unique: true})
end
