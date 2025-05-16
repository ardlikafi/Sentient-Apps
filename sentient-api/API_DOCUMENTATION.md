# Sentient API Documentation

## Overview
This document provides comprehensive documentation for the Sentient API. The API follows REST principles and uses JSON for request and response bodies.

## Base URL
```
http://localhost:8000/api
```

## Authentication
The API currently supports JWT (JSON Web Token) authentication. Additional authentication methods (API Key, OAuth, Basic Auth) are planned for future implementation.

### JWT Authentication
To authenticate requests, include the JWT token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## API Endpoints

### Authentication

#### Register User
- **URL**: `/register`
- **Method**: `POST`
- **Auth Required**: No
- **Body**:
  ```json
  {
    "name": "string",
    "email": "string",
    "password": "string",
    "password_confirmation": "string"
  }
  ```
- **Success Response**:
  - **Code**: 201 Created
  - **Content**:
    ```json
    {
      "message": "User successfully registered",
      "user": {
        "id": "integer",
        "name": "string",
        "email": "string",
        "created_at": "datetime"
      }
    }
    ```

#### Login
- **URL**: `/login`
- **Method**: `POST`
- **Auth Required**: No
- **Body**:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:
    ```json
    {
      "access_token": "string",
      "token_type": "Bearer",
      "expires_in": "integer"
    }
    ```

#### Get User Profile
- **URL**: `/profile`
- **Method**: `GET`
- **Auth Required**: Yes
- **Headers**:
  ```
  Authorization: Bearer <your_jwt_token>
  ```
- **Success Response**:
  - **Code**: 200 OK
  - **Content**:
    ```json
    {
      "id": "integer",
      "name": "string",
      "email": "string",
      "created_at": "datetime",
      "updated_at": "datetime"
    }
    ```

## Planned Endpoints

### User Management
- GET `/users` - List all users
- GET `/users/{id}` - Get user details
- PUT `/users/{id}` - Update user
- DELETE `/users/{id}` - Delete user

### Profile Management
- GET `/profiles` - List all profiles
- GET `/profiles/{id}` - Get profile details
- POST `/profiles` - Create profile
- PUT `/profiles/{id}` - Update profile
- DELETE `/profiles/{id}` - Delete profile

## Error Responses

### Common Error Codes
- 400 Bad Request - Invalid request parameters
- 401 Unauthorized - Authentication required
- 403 Forbidden - Insufficient permissions
- 404 Not Found - Resource not found
- 422 Unprocessable Entity - Validation error
- 500 Internal Server Error - Server error

### Error Response Format
```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": [] // Optional array of detailed error messages
  }
}
```

## Rate Limiting
Rate limiting will be implemented in future versions to prevent abuse of the API.

## Future Authentication Methods

### API Key Authentication
- Will be implemented for service-to-service communication
- API keys will be managed through a dedicated interface

### OAuth 2.0
- Will support standard OAuth 2.0 flows
- Will include refresh token mechanism

### Basic Auth
- Will be available as an alternative authentication method
- Will use standard Basic Auth header format

## Testing
API testing can be done using Postman. A Postman collection will be provided in the future.

## Versioning
API versioning will be implemented in the future using URL versioning:
```
http://localhost:8000/api/v1/
```

## Support
For API support or questions, please contact the development team.

---

*Note: This documentation is a work in progress and will be updated as new features are implemented.* 