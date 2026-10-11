# Concesionaria de Vehículos

Trabajo Práctico N.º 1 - Programación IV - UTN.

Aplicación desarrollada con Ruby on Rails que implementa un back-office administrativo, vistas públicas para clientes y una API JSON versionada para la gestión integral de una concesionaria de vehículos.

## Objetivo

El sistema permite la publicación, consulta y administración del inventario de vehículos, la solicitud y gestión de turnos para pruebas de manejo (Test Drives), solicitudes de tasación de vehículos usados y el registro de ventas.

Dispone de:
- **Vistas públicas web:** Formularios de acceso público para que clientes soliciten turnos de Test Drive (`/test_drives/new`) y tasaciones de vehículos usados (`/appraisals/new`).
- Un **back-office administrativo** autenticado para vendedores y administradores (`/admin`).
- Una **API REST** bajo `/api/v1` destinada a usuarios finales para consultar el catálogo de vehículos y realizar operaciones, lista para ser consumida por un frontend externo.

## Tipos de usuario y Autenticación

El sistema contempla dos roles de usuario:

- `seller`: vendedor / administrador con acceso exclusivo al back-office administrativo (`/admin`).
- `customer`: cliente comprador / solicitante para operaciones web y consultas de la API.

### Esquema de Autenticación:
- **Back-office:** Autenticación por sesión estándar de Rails (`session[:user_id]`) con contraseñas seguras cifradas con `has_secure_password` (`bcrypt`).
- **API REST (/api/v1):** Autenticación mediante Token Bearer en los encabezados HTTP:
  ```http
  Authorization: Bearer <api_token>
  ```

## Modelo de datos

El sistema cuenta con los siguientes modelos principales:

### User
Representa a los usuarios del sistema (clientes y vendedores).
- Atributos: `name`, `email` (único y validado), `password_digest`, `role` (`customer` o `seller`), `api_token`.
- Relaciones: Posee test drives, solicitudes de tasación y registro de ventas como cliente o vendedor.

### Brand y VehicleModel
- **Brand:** Representa las marcas comerciales (Toyota, Ford, Volkswagen, etc.).
- **VehicleModel:** Representa los modelos pertenecientes a una marca (Corolla, Focus, Golf, etc.).

### Vehicle
Representa las unidades disponibles en la concesionaria.
- Atributos: `year`, `price`, `currency` (ARS / USD), `km`, `condition` (nuevo/usado), `status` (`available`, `reserved`, `sold`), `description`.
- **Active Storage:** Soporte para múltiples fotografías por vehículo con vista previa y borrado individual.
- Relaciones: Pertenece a un modelo, posee test drives y puede tener una venta asociada.

### TestDrive
Gestiona las solicitudes de pruebas de manejo para un vehículo.
- Atributos: `scheduled_date`, `scheduled_time`, `status` (`pending`, `confirmed`, `cancelled`).
- Validaciones: Impide fechas en el pasado, turnos superpuestos para el mismo vehículo en el mismo horario y bloquea solicitudes sobre vehículos ya vendidos.

### Sale
Registra una operación comercial de compra-venta.
- Atributos: `price`, `currency`, `payment_method`, `sold_at`, `notes`.
- Relaciones: Vincula el vehículo vendido con el cliente comprador y el vendedor interviniente.
- Regla de negocio: Al concretar una venta, actualiza de forma automática el estado del vehículo a `sold`.

### Appraisal
Permite a los usuarios solicitar una tasación económica para entregar su auto usado.
- Atributos: `make`, `car_model`, `year`, `km`, `description`, `photo` (Active Storage), `status` (`pending`, `quoted`, `rejected`), `quoted_price`, `admin_notes`.
- Relaciones: Puede pertenecer a un usuario registrado o asociarse mediante los datos de contacto provistos.

## Notificaciones por Correo (Action Mailer)

El sistema implementa notificaciones automáticas con plantillas multipart (HTML y texto plano):

- **TestDriveMailer:**
  - `confirmation_email`: Notificación inmediata al cliente con el resumen del turno solicitado.
  - `status_update_email`: Notificación cuando el vendedor confirma o cancela el turno desde el panel.
- **AppraisalMailer:**
  - `received_email`: Confirmación de recepción de datos del vehículo para peritaje.
  - `quoted_email`: Notificación al cliente con el valor tasado cotizado y las observaciones del perito.

## API RESTful (/api/v1)

La API cuenta con endpoints para consumo externo y dispone de una colección lista para importar en la raíz del proyecto (`concesionaria_api.postman_collection.json`):

- **Autenticación:**
  - `POST /api/v1/registrations`: Registro de nuevo cliente (devuelve token).
  - `POST /api/v1/sessions`: Inicio de sesión (devuelve token).
  - `DELETE /api/v1/sessions`: Cierre de sesión e invalidación de token.
  - `GET /api/v1/profile`: Perfil del usuario autenticado y resumen de actividad.
- **Vehículos:**
  - `GET /api/v1/vehicles`: Catálogo con filtros por marca, condición y ordenamiento de precio.
  - `GET /api/v1/vehicles/:id`: Detalle completo de la unidad.
- **Test Drives:**
  - `GET /api/v1/test_drives`: Historial de turnos del cliente autenticado.
  - `POST /api/v1/test_drives`: Solicitud de nuevo turno.
- **Tasaciones:**
  - `GET /api/v1/appraisals`: Historial de cotizaciones del cliente.
  - `POST /api/v1/appraisals`: Envío de datos de vehículo usado para tasación.

## Instalación y Configuración

### Requisitos:
- Ruby 3.2+
- Rails 8.1+
- SQLite3
- Bundler

### Pasos:
1. Clonar el repositorio y acceder a la carpeta:
   ```bash
   git clone https://github.com/totomonaco/concesionaria.git
   cd concesionaria
   ```

2. Instalar las dependencias:
   ```bash
   bundle install
   ```

3. Preparar la base de datos y cargar los datos de prueba iniciales:
   ```bash
   bin/rails db:prepare
   bin/rails db:seed
   ```

> **Usuario Administrador de prueba (creado en seeds):**  
> - **Email:** `admin@concesionaria.com`  
> - **Password:** `password123`  
> - **Acceso back-office:** `/admin/login`

## Ejecutar el proyecto

Iniciar el servidor web de desarrollo:
```bash
bin/rails server
```
La aplicación estará accesible en [http://localhost:3000](http://localhost:3000).

## Pruebas Automatizadas

El proyecto incluye una suite de 27 pruebas automáticas (Minitest) cubriendo modelos, Action Mailer y la API v1.

Para ejecutar la suite completa:
```bash
bin/rails test
```
