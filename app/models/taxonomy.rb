class Taxonomy
  include Mongoid::Document
  field :sub_cat_name
  field :parent_id
  field :taxon_id
  index( { parent_id: 1},{ background: true } )
  index( { sub_cat_name: 1},{ background: true } )
  index( { id: 1},{unique: true} )
end
