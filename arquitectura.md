# Arquitectura Flutter — BañoVisión

Este documento describe la arquitectura usada en la aplicación móvil **BañoVisión**.

La aplicación sigue una arquitectura **feature-first simplificada**, diseñada para aplicaciones móviles que consumen APIs REST.

---

# Estructura del Proyecto

```
lib/

core/
   api/
   storage/
   theme/

features/

   auth/
      data/
         auth_api.dart
         auth_repository.dart
      presentation/
         login_page.dart
         auth_provider.dart

   bathrooms/
      data/
         bathrooms_api.dart
      presentation/
         bathrooms_page.dart

   incidents/
      data/
      presentation/

shared/
   widgets/
```

---

# Core Layer

El directorio `core` contiene componentes reutilizables para toda la aplicación.

```
core/
   api/
   storage/
   theme/
```

## ApiClient

Centraliza todas las conexiones HTTP usando **Dio**.

Archivo:

```
core/api/api_client.dart
```

Responsabilidades:

- Configurar la URL base del backend
- Añadir headers globales
- Registrar interceptores

---

## Secure Storage

Se usa para guardar información sensible como el **JWT**.

Archivo:

```
core/storage/secure_storage.dart
```

Implementación:

- Usa `flutter_secure_storage`
- Guarda tokens de forma segura

Funciones principales:

```
saveToken()
getToken()
deleteToken()
```

---

# Interceptors

Los interceptores permiten modificar todas las requests HTTP.

Se usa un interceptor para enviar automáticamente el JWT.

Archivo:

```
core/api/interceptors/auth_interceptor.dart
```

Funcionamiento:

```
Request HTTP
     ↓
AuthInterceptor
     ↓
Obtiene token desde SecureStorage
     ↓
Añade header Authorization
     ↓
Request al backend
```

Header enviado:

```
Authorization: Bearer JWT
```

---

# Arquitectura de Features

Cada funcionalidad se organiza dentro de `features`.

Ejemplo:

```
features/auth
features/bathrooms
features/incidents
```

Cada feature tiene su propio código.

---

# Auth Feature

Estructura:

```
auth/

data/
   auth_api.dart
   auth_repository.dart

presentation/
   login_page.dart
   auth_provider.dart
```

---

# AuthApi

Archivo:

```
auth/data/auth_api.dart
```

Responsabilidad:

- Comunicarse con el backend

Ejemplo:

```
POST /auth/google
```

Request:

```
{
  "idToken": "google_token"
}
```

Response:

```
{
  "accessToken": "jwt_del_backend"
}
```

---

# AuthRepository

Archivo:

```
auth/data/auth_repository.dart
```

Responsabilidades:

- Manejar Google Sign In
- Enviar el idToken al backend
- Guardar el JWT en SecureStorage

Flujo:

```
Google Sign In
      ↓
Obtener idToken
      ↓
Enviar a backend
      ↓
Backend valida con Google
      ↓
Backend devuelve JWT
      ↓
Guardar JWT en SecureStorage
```

---

# AuthProvider

Archivo:

```
auth/presentation/auth_provider.dart
```

Responsabilidad:

Conectar la UI con el repository.

Gestiona:

- loading
- errores
- estado de login

---

# LoginPage

Archivo:

```
auth/presentation/login_page.dart
```

Responsabilidad:

Mostrar la interfaz de login.

Componentes:

- Logo
- Input email
- Input password
- Botón continuar
- Botón login con Google

---

# Flujo de Autenticación

```
Usuario presiona login con Google
           ↓
AuthProvider
           ↓
AuthRepository
           ↓
GoogleSignIn SDK
           ↓
Obtiene idToken
           ↓
AuthApi
           ↓
Backend
           ↓
Backend devuelve JWT
           ↓
JWT se guarda en SecureStorage
```

---

# Uso del JWT

Todas las requests HTTP usan automáticamente el JWT gracias al interceptor.

Ejemplo:

```
GET /bathrooms
Authorization: Bearer JWT
```
