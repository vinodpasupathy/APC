require 'spreadsheet'
class Taxon
  include Mongoid::Document
  field :main_cat_name
  field :manu_id
  index({ main_cat_name: 1},{ background: true })
  index({ id: 1},{unique: true})
end
