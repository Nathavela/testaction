require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "Verificar si el nombre del prodcuto no es nulo" do
    product= Product.new(name:"mesa",price:20,description:"grande")
    assert_not_nil product.name 
  end 

  test "Se espera que el index carge correctamente" do
    get products_path 
    assert_response :success
  end

  test "Verificar si el producto se esta creando correctamente" do
    product= Product.new(name:"cortina",price:15,description:"larga")
    assert product.valid? 
    assert_equal "cortina", product.name
  end

  test "Verifica si existe la vista" do
    get products_path 
    assert_select "h1", "Products"
  end

  # test "Verificar si el nombre esta vacio" do
  #   product= Product.new(price:15,description:"larga")
  #   assert_not product.valid?
  #   assert_includes product.errors[:name],"ERROR"
  # end

  test "Verifica si el producto es diferente" do
    product= Product.new(name:"cortina",price:15,description:"larga")
    assert product.valid? 
    assert_not_equal "plumon", product.name
  end

  test "Verifica que una cadena de texto cumpla con la expresion" do
    product= Product.new(name:"cortina",price:15,description:"larga")
    assert_match /cortina/i,product.name 
  end
  
  test "Verifica si se realizaron cambios" do
    product= products(:carpeta) 
    assert_difference('Product.count' , -1) do
      delete product_url(product)
    end
  end

  test "Verifica si no se realizaron cambios" do
    product= products(:carpeta) 
    assert_no_difference('Product.count') do
      delete product_url(product)
    end
  end




  # setup do
  #   @product = products(:one)
  # end

  # test "should get index" do
  #   get products_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_product_url
  #   assert_response :success
  # end

  # test "should create product" do
  #   assert_difference("Product.count") do
  #     post products_url, params: { product: { description: @product.description, name: @product.name, price: @product.price } }
  #   end

  #   assert_redirected_to product_url(Product.last)
  # end

  # test "should show product" do
  #   get product_url(@product)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_product_url(@product)
  #   assert_response :success
  # end

  # test "should update product" do
  #   patch product_url(@product), params: { product: { description: @product.description, name: @product.name, price: @product.price } }
  #   assert_redirected_to product_url(@product)
  # end

  # test "should destroy product" do
  #   assert_difference("Product.count", -1) do
  #     delete product_url(@product)
  #   end

  #   assert_redirected_to products_url
  # end
end
