class ProductsController < ApplicationController

skip_before_filter :verify_authenticity_token, only: [:product_compare,:manu_category_compare,:manu_index_product_compare]
skip_before_action :check_session, :only=>[:main_category,:sub_category,:product_desc,:product_compare,:manu_category,:manu_category_desc,:manu_category_compare,:manu_index_category, :manu_index_sub_category, :manu_index_product_desc,:manu_index_product_compare,:search,:search_desc,:login,:validate_login]

require 'will_paginate/array'

def new
  @user=User.new
  render :layout=>false
end

def create
  @user=User.new(user_params)
    if @user.save
      redirect_to :action=>"login_page"
    else
      redirect_to :action=>"new"
    end
end

def login_page
  @user=User.new
end
def validate_login
 params.permit!
 @user=User.where params[:user]
 if not @user.blank?
  session[:user_id]=@user.first.id
  redirect_to :action=>"import"
  else
  redirect_to root_path 
  end
end


  def import

     @product=Product.new

     render :layout=>false
  end

  def import_process

     file=params[:product][:file1]

     filename=params[:product][:file1].original_filename

     @product=Product.bro(file)
    
     unless @product.blank?
    
     redirect_to :action=> "import"
 
     flash[:notice] = "Your file has been successfully imported in a database..."
   
     else

     flash[:notice] = "Invalid file headers or file format"
     
     redirect_to :action=> "import"
    
     end

  end


  def main_category

      @taxon=Taxon.all    
      
      @manufacture=Manufacture.all

      #@taxon_id=params[:format] || params[:id]

      #@product=Product.all

      #@im=@product.where(:main_cat_name=>@taxon_id).pluck(:image)[0]

  end

  def sub_category

    unless params.include?("is")
      @taxon_id = params[:format] || params[:id]
    end
              
      unless params.include?("is") || Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).present?



        if Taxon.where(:id=>@taxon_id).present?
          @main_cat_name=Taxon.where(:id=>@taxon_id)
          $main_cat_name=Taxon.where(:id=>@taxon_id)
          $taxon_main=Taxonomy.where(:taxon_id=>BSON::ObjectId.from_string(@taxon_id))

          @taxon=$taxon_main.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id))
        

        else
          @main_cat_name=Taxon.where(:id=>Taxonomy.where(:id=>BSON::ObjectId.from_string(@taxon_id)).pluck(:taxon_id)[0])
          $main_cat_name=@main_cat_name
          if $taxon_main.blank? || $taxon_main.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id)).blank?
            @taxon=Taxonomy.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id))
          else
            @taxon=$taxon_main.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id))
          end
          @ta=@taxon.pluck(:parent_id)[0]

        end

      else
        if params.include?("is")
          @product1=Product.where(:id.in=>params[:is].join(' ').split(' ').uniq)
          @ta=@product1.pluck(:taxonomy_id).uniq[0]
          @taxon_id=@product1.pluck(:taxonomy_id).uniq[0]
          @main_cat_name=Taxon.where(:id=>@product1.pluck(:taxon_id)[0])
        else
          @main_cat_name=Taxon.where(:id=>Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).pluck(:taxon_id)[0])
          @product1=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id))
          @ta=@taxon_id
        end
          @product=@product1.paginate(:page => params[:page], :per_page => 10)
      end
      $taxo=[]
        unless Taxon.where(:id=>@taxon_id).present?


          begin
              s=BSON::ObjectId.from_string(@main_cat_name.pluck(:id)[0])
              if Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).present?
                @tax=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta))
              else
                @tax=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta))
              end
              tax1=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta)).pluck(:parent_id)[0]
              $taxo<<@tax
              @ta=@tax.pluck(:parent_id)[0]



          end until tax1==s
        end
  end

  def product_desc

       
    @prms=params[:format]
    @product=Product.where(:id=>BSON::ObjectId.from_string(params[:format]))
    @related=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@product.pluck(:taxonomy_id)[0])).not.where(:id=>@product.pluck(:_id))

  end

  def product_compare
    @comp=[]
    if params.include?("is")

      $pros=Product.where(:id.in=>params[:is].flatten.uniq)
      $pros.pluck(:property).map{|i| @comp << i.keys}
    else
      
      $pros1=$pros.flatten-$pros.flatten.select{|p| p.item_id == params[:format]}
      $pros.clear
      $pros=$pros1
      $pros.map{|p| @comp << p.property.keys}
    end
      
 
      

      @names=["","manu_name","mp_number","product_name","image",[@comp.flatten.uniq]].flatten
    
  end

  def manu_category

    unless params.include?("is")
      @taxon_id = params[:format] || params[:id]
    end

    unless params.include?("is") || Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).present?
      
      if Product.where(:manu_id=>BSON::ObjectId.from_string(@taxon_id)).present?
    
        @manu_id=@taxon_id
    
        $manu_name=Manufacture.where(:id=>@manu_id)
    
        @taxon=Taxon.where(:id.in=>Product.where(:manu_id=>BSON::ObjectId.from_string(@manu_id)).pluck(:taxon_id).flatten.uniq).flatten
   
        $taxonomy=Taxonomy.where(:id.in=>Product.where(:manu_id=>BSON::ObjectId.from_string(@manu_id)).pluck(:path).flatten.compact.uniq)
           

      else

        @taxon=$taxonomy.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id))
        @main=Taxon.where(:id=>@taxon.pluck(:taxon_id)[0])
        $main=Taxon.where(:id=>@taxon.pluck(:taxon_id)[0])
        @ta=@taxon.pluck(:parent_id)[0]
      end

    else

      if params.include?("is")

          @product1=Product.where(:id.in=>params[:is].join(' ').split(' ').uniq)
          @ta=@product1.pluck(:taxonomy_id).uniq[0]
          @taxon_id=@product1.pluck(:taxonomy_id).uniq[0]
          @main=Taxon.where(:id=>@product1.pluck(:taxon_id)[0])
        else

        @product1=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).where(:manu_id=>BSON::ObjectId.from_string($manu_name.pluck(:id)[0]))
        @main=Taxon.where(:id=>@product1.pluck(:taxon_id)[0])
        @ta=@taxon_id
        end
         @product=@product1.paginate(:page => params[:page], :per_page => 10)

    end
$taxo1=[]
 unless Manufacture.where(:id=>@taxon_id).present? || Taxon.where(:id=>@taxon_id).present?
     begin
      
       s=BSON::ObjectId.from_string(@main.pluck(:id)[0])
          
          
            
            @tax=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta))
          
        tax1=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta)).pluck(:parent_id)[0]
     
     
     
 $taxo1<<@tax

 @ta=@tax.pluck(:parent_id)[0]

end until tax1==s
end
  end

  def manu_category_sub

  end

  def manu_category_compare

@comp=[]
    if params.include?("is")

      $pros1=Product.where(:id.in=>params[:is].flatten.uniq)
      $pros1.pluck(:property).map{|i| @comp << i.keys}
    else

      $pros11=$pros1.flatten-$pros1.flatten.select{|p| p.item_id == params[:format]}
      $pros1.clear
      $pros1=$pros11
      $pros1.map{|p| @comp << p.property.keys}
    end
      
 
      

      @names=["","manu_name","mp_number","product_name","image",[@comp.flatten.uniq]].flatten
    
            
  end

  def manu_category_desc
  
   
    @prms=params[:format]
    @product=Product.where(:id=>BSON::ObjectId.from_string(params[:format]))
@related=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@product.pluck(:taxonomy_id)[0])).where(:manu_id=>BSON::ObjectId.from_string(@product.pluck(:manu_id)[0])).not.where(:id=>@product.pluck(:_id))
    
  end

  
  def manu_index_category

    @taxon=Taxon.all

  end

  def manu_index_sub_category
 
 unless params.include?("is")
      @taxon_id = params[:format] || params[:id]
    end

     unless params.include?("is") || Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id)).present? 
      if Taxon.where(:id=>BSON::ObjectId.from_string(@taxon_id)).present?
          @tax=@taxon_id
          $taxon_name=Taxon.where(:id=>@taxon_id)
          @main=$taxon_name
          $main=$taxon_name

          @manufacture=Manufacture.where(:id.in=>Product.where(:taxon_id=>BSON::ObjectId.from_string(@taxon_id)).pluck(:manu_id).uniq)
      elsif Product.where(:manu_id=>BSON::ObjectId.from_string(@taxon_id)).present?
          $manufacture=Manufacture.where(:id=>@taxon_id)
          $manu=$manufacture.pluck(:manu_name)[0]
          $taxonomy_index=Taxonomy.where(:id.in=>Product.where(:manu_id=>BSON::ObjectId.from_string(@taxon_id)).pluck(:path).flatten.uniq.sort)
          @sub_taxonomy=$taxonomy_index.where(:parent_id=>BSON::ObjectId.from_string($taxon_name.pluck(:id)[0]))
          @main=Taxon.where(:id=>@sub_taxonomy.pluck(:taxon_id)[0])
          @ta=@sub_taxonomy.pluck(:parent_id)[0]
      else
          @sub_taxonomy=$taxonomy_index.where(:parent_id=>BSON::ObjectId.from_string(@taxon_id))
          @main=Taxon.where(:id=>@sub_taxonomy.pluck(:taxon_id)[0])
          @ta=@sub_taxonomy.pluck(:parent_id)[0]
      end
    else
      if params.include?("is")
          @product1=Product.where(:id.in=>params[:is].join(' ').split(' ').uniq)
          @ta=@product1.pluck(:taxonomy_id).uniq[0]
          @taxon_id=@product1.pluck(:taxonomy_id).uniq[0]
          @main=Taxon.where(:id=>@product1.pluck(:taxon_id)[0])
        else

        @product1=Product.where(:manu_id=>BSON::ObjectId.from_string($manufacture.pluck(:id)[0])).where(:taxonomy_id=>BSON::ObjectId.from_string(@taxon_id))
        @main=Taxon.where(:id=>@product1.pluck(:taxon_id)[0])
        @ta=@taxon_id
        end         
        @product=@product1.paginate(:page => params[:page], :per_page => 10)
    end
    $taxo2=[]
 unless Taxon.where(:id=>BSON::ObjectId.from_string(@taxon_id)).present? || Product.where(:manu_id=>BSON::ObjectId.from_string(@taxon_id)).present?
     begin
   
       s=BSON::ObjectId.from_string(@main.pluck(:id)[0])
 
            @tax=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta))
 
        tax1=Taxonomy.where(:id=>BSON::ObjectId.from_string(@ta)).pluck(:parent_id)[0]
     
     
     
 $taxo2<<@tax

 @ta=@tax.pluck(:parent_id)[0]

end until tax1==s
end
  end

  def manu_index_product_desc

    @prms=params[:format]
    @product=Product.where(:id=>BSON::ObjectId.from_string(params[:format]))
    @related=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@product.pluck(:taxonomy_id)[0])).where(:manu_id=>BSON::ObjectId.from_string($manufacture.pluck(:id)[0])).not.where(:id=>@product.pluck(:_id))
  end

  def manu_index_product_compare

    @comp=[]
    if params.include?("is")
      $pros2=Product.where(:id.in=>params[:is].flatten.uniq)
      $pros2.pluck(:property).map{|i| @comp << i.keys}
    else
      
      $pros12=$pros2.flatten-$pros2.flatten.select{|p| p.item_id == params[:format]}
      $pros2.clear
      $pros2=$pros12
      $pros2.map{|p| @comp << p.property.keys}
    end
      
      @names=["","manu_name","mp_number","product_name","image",[@comp.flatten.uniq]].flatten

  end

def search

@search=params[:search]

@product3= Product.where(product_name: /.*#{@search}*./i)

$prod=@product3.collect{|i| i.id}
@product=@product3.paginate(:page => params[:page], :per_page => 10)

end

def search_desc

@prms=params[:format]
@product=Product.where(:id=>BSON::ObjectId.from_string(params[:format]))
@related1=Product.where(:taxonomy_id=>BSON::ObjectId.from_string(@product.pluck(:taxonomy_id)[0])).not.where(:id=>@product.pluck(:_id))
@related=@related1.paginate(:page => params[:page], :per_page => 10)
end

def logout
    session[:user_id]=nil
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit!
  end


end 
