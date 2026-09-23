puts "Creando marcas y modelos..."

brands_and_models = {
  "Toyota" => ["Corolla", "Hilux", "Yaris", "Etios", "RAV4", "SW4"],
  "Ford" => ["Focus", "Ranger", "Territory", "Ka", "Fiesta"],
  "Volkswagen" => ["Golf GTI", "Amarok", "Polo", "Vento", "T-Cross", "Nivus"],
  "Chevrolet" => ["Cruze", "Onix", "Tracker", "S10", "Spin"],
  "Peugeot" => ["208", "2008", "3008", "Partner"],
  "Fiat" => ["Cronos", "Toro", "Pulse", "Mobi", "Strada"],
  "Honda" => ["Civic", "HR-V", "CR-V", "Fit"]
}

brands_and_models.each do |brand_name, models|
  brand = Brand.find_or_create_by!(name: brand_name)
  models.each do |model_name|
    VehicleModel.find_or_create_by!(name: model_name, brand: brand)
  end
end

puts "¡Marcas y Modelos cargados con éxito!"
