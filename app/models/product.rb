require 'spreadsheet'

require 'roo'

require 'csv'

require 'byebug'

class Product

  include Mongoid::Document 
  
  field :item_id
  
  field :glo_desc
  
  field :product_name
  
  field :mp_number
  
  field :taxon_id
  
  field :taxonomy_id
  
  field :manu_id
  
  field :html
  
  field :pdf
  
  field :image
  
  field :d_long
  
  field :d_short
  
  field :d_bullet
  
  field :d_copy
  
  field :extra
  
  field :property
  
  field :path

  field :property_extra

  index( { manu_id: 1},{ background: true } )
  index( { taxon_id: 1},{ background: true } )
  index( { id: 1},{unique: true} )
  index( { taxonomy_id: 1},{ background: true } )
  index( { product_name: 1},{ background: true } )
  index( { glo_desc: 1},{ background: true } )
  index( { image: 1},{ background: true } )

  def self.bro(file)
  case File.extname(file.original_filename)
  
  when ".csv" 
   @file = File.open(file.tempfile,"r").collect{|o| o.chomp.split("\t")}
#    @file=CSV.read(file.tempfile)
  when ".txt" 
  
    #byebug

    @ff=File.open(file.tempfile, "r",:headers=>true)
    
    @ss=@ff.collect{|p| p.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')}

    @file=@ss.collect{|a|a.chomp.split(",").collect{|a| a.split("\t")}}
    
  when ".xlsx" 
  
    @file=File.open(file.tempfile,"r").collect{|p| p.chomp.split("\t")}
    
  end

       
    @id=@file[0].index("ID")
    
    @gd=@file[0].index("GD")
    
    @mn=@file[0].index("M Name")
    
    @ml=@file[0].index("M Logo")
    
    @mpn=@file[0].index("M Number")
    
    @pn=@file[0].index("Name")
    
    @dl=@file[0].index("D Long")
    
    @ds=@file[0].index("D Short")
    
    @dc=@file[0].index("D Copy")
    
    @db=@file[0].index("D Bullet")
    
    @tax=@file[0].index("T")

    @html=@file[0].select{|a| a.start_with?("H")}.map{|i| @file[0].index(i)}.compact
    
    @extra=@file[0].select{|a| a.start_with?("E")}.map{|i| @file[0].index(i)}.compact
    
    @pdf=@file[0].select{|a| a.start_with?("P")}.map{|i| @file[0].index(i)}.compact
    
    @img=@file[0][1..-1].select{|a| a.start_with?("I")}.map{|i| @file[0].index(i)}.compact

    @attrstartloc=@file[0].index{|i| i.starts_with?("A")}
    
    @tax_ids=[]
    
    $upcount,$newcount=[],[];
   
    @file.each do |line|

   
      next if line[0].match(/[0-9]/) == nil
   
        @taxonomy= line[@tax].split('>')
   
      unless Taxon.where(:main_cat_name=>@taxonomy[0]).present?
   
        @taxon=Taxon.new(:main_cat_name=>@taxonomy[0])
   
        @taxon.save(:validate=>true)
   
      end
   
      taxon=@taxonomy[0]
   
      @taxon_id=Taxon.where(:main_cat_name=>@taxonomy[0]).pluck(:id)[0]
   
     @taxonomy[1..-1].each do |tax|

        if Taxon.where(:main_cat_name=>taxon).present?
        
          @p_id=Taxon.where(:main_cat_name=>taxon).pluck(:id)[0]
        
        elsif Taxonomy.where(:sub_cat_name=>taxon).present?
        
          @p_id=Taxonomy.where(:sub_cat_name=>taxon).pluck(:id)[0]
        
        end
        
        unless Taxonomy.where(:sub_cat_name=>tax).where(:parent_id=>@p_id).present?
        
          @taxonomy=Taxonomy.new(:sub_cat_name=>tax,:parent_id=>@p_id,:taxon_id=>@taxon_id)
        
          @taxonomy.save
        
        end
        
        taxon=tax
        
        @taxonomy_id=Taxonomy.where(:sub_cat_name=>tax,:parent_id=>@p_id,:taxon_id=>@taxon_id).pluck(:id)[0]
        
        @tax_ids <<  @taxonomy_id
        
      end
      
      unless @extra.empty?
      
        @extra_data=@extra.map{|p| Hash[@file[1][p]=>line[p]]}
      
      end
        
       
      unless Manufacture.where(:manu_name=>line[@mn]).present?
      
        @manu=Manufacture.new(:manu_name=>line[@mn],:manu_logo=>line[@ml])
      
        @manu.save
      
      end
      
        @manu_id=Manufacture.where(:manu_name=>line[@mn],:manu_logo=>line[@ml]).pluck(:id)[0]
      
        @html_link=@html.map{|p| line[p]}.compact
      
        @pdf_link=@pdf.map{|p| line[p]}.compact
      
        @img_link=@img.map{|p| line[p]}.compact
      
        @attri_data=line[@attrstartloc..-1].each_slice(3).to_a
          
        @attribute_data = @attri_data.reject{|p| p[0]==nil || p[1]==nil}.map{|p| [p[0],p[1..-1].compact.join('  ')]}

        @attribute_data1 = @attri_data.reject{|p| p[0]==nil || p[1]==nil}.map{|p| {p[0]=>p[1..-1].compact.join('  ')} }

        if Manufacture.where(:manu_name=>line[@mn]).present?
  
          @man=BSON::ObjectId.from_string(Manufacture.where(:manu_name=>line[@mn]).pluck(:id)[0])

        end

        if Product.where(:manu_id=>@man).where(:mp_number=>line[@mpn]).present?

         Product.where(:manu_id=>@man).where(:mp_number=>line[@mpn]).delete
        @product=Product.new(:item_id=>line[@id],:glo_desc=>line[@gd],:product_name=>line[@pn],:mp_number=>line[@mpn],
        :taxon_id=>@taxon_id,:taxonomy_id=>@taxonomy_id,:manu_id=>@manu_id,:html=>@html_link,
        :pdf=>@pdf_link,:image=>@img_link,:d_long=>line[@dl],:d_short=>line[@ds],
        :d_bullet=>line[@db],:d_copy=>line[@dc],:extra=>@extra_data,:property=>Hash[*@attribute_data.flatten],:path=>@tax_ids.flatten.compact.uniq.sort,:property_extra=>@attribute_data1)

        @product.save(validate=>true)
        $upcount << @product

        else
        @product=Product.new(:item_id=>line[@id],:glo_desc=>line[@gd],:product_name=>line[@pn],:mp_number=>line[@mpn],
        :taxon_id=>@taxon_id,:taxonomy_id=>@taxonomy_id,:manu_id=>@manu_id,:html=>@html_link,
        :pdf=>@pdf_link,:image=>@img_link,:d_long=>line[@dl],:d_short=>line[@ds],
        :d_bullet=>line[@db],:d_copy=>line[@dc],:extra=>@extra_data,:property=>Hash[*@attribute_data.flatten],:path=>@tax_ids.flatten.compact.uniq.sort,:property_extra=>@attribute_data1)
  
        @product.save(validate=>true)
        $newcount << @product
        end
        @tax_ids.clear
  
    end
  
  end

#def as_indexed_json
#    as_json(except: [:id, :_id])
 # end
end

