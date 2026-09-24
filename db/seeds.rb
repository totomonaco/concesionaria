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

# Crear usuario administrador/vendedor de prueba si no existe
admin_user = User.find_or_create_by!(email: "admin@concesionaria.com") do |u|
  u.name = "Vendedor Principal"
  u.password = "password123"
  u.role = :seller
end
puts "Usuario Admin listo: admin@concesionaria.com / password123"

# Crear usuario cliente de prueba si no existe
customer_user = User.find_or_create_by!(email: "cliente@ejemplo.com") do |u|
  u.name = "Martín Gómez"
  u.password = "password123"
  u.role = :customer
end

# Crear vehículos de ejemplo si no existen
corolla_model = VehicleModel.find_by(name: "Corolla")
if corolla_model && Vehicle.where(vehicle_model: corolla_model).none?
  v1 = Vehicle.create!(
    vehicle_model: corolla_model,
    year: 2023,
    price: 24500000,
    currency: "ars",
    km: 18000,
    used: true,
    description: "Excelente estado, service oficial al día, único dueño."
  )

  # Agendar un test drive de prueba
  TestDrive.find_or_create_by!(
    vehicle: v1,
    user: customer_user,
    scheduled_date: Date.current + 2.days,
    scheduled_time: Time.zone.parse("11:00")
  ) do |td|
    td.status = :pending
  end
end

