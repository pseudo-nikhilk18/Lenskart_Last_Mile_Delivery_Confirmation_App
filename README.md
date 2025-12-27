# Last-Mile Delivery Confirmation System (Lenskart Assignment)

A production-oriented 3-tier application for last-mile delivery confirmation, enabling delivery agents to verify shipments using OTP-based authentication.

## System Architecture

[View Detailed Architecture Diagram](./architecture/architecture.md)

The system follows a strict 3-tier architecture:

- **Presentation Tier**: Flutter-based Android mobile application
- **Application Tier**: Node.js/Express RESTful API service
- **Data Tier**: MySQL database for persistent storage

## Technology Stack

- **Mobile App**: Flutter (Dart)
- **Backend**: Node.js, Express.js
- **Database**: MySQL
- **Dependencies**: 
  - Backend: express, mysql2, dotenv, cors
  - Mobile: http package for API communication

## Prerequisites

- Node.js (v18 or higher)
- MySQL Server (v8.0 or higher)
- Flutter SDK (v3.0 or higher)
- Android Studio (for Android development)
- MySQL Workbench (optional, for database management)

## Project Structure

```
Lenskart_Last_Mile_Delivery_App/
├── backend/                 # Application Tier
│   ├── config/             # Database configuration
│   ├── controllers/       # Request handlers
│   ├── services/          # Business logic
│   ├── repositories/      # Database queries
│   ├── routes/            # API endpoints
│   ├── utils/             # Utilities (logging)
│   └── constants/         # Constants
├── mobile_app/            # Presentation Tier
│   └── lib/
│       ├── screens/       # UI screens
│       ├── services/      # API service
│       ├── models/        # Data models
│       └── utils/         # Utilities
└── database/              # Data Tier
    ├── schema.sql         # Database schema
    └── seed.sql           # Sample data
```

## Setup Instructions

### 1. Database Setup

1. Open MySQL Workbench and connect to your local MySQL instance
2. Execute `database/schema.sql` to create the database and table
3. Execute `database/seed.sql` to insert sample shipment data

```sql
-- Run in MySQL Workbench
source database/schema.sql;
source database/seed.sql;
```

### 2. Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file in the backend directory:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=last_mile_delivery
PORT=3000
```

4. Start the backend server:
```bash
npm start
```

The server will run on `http://localhost:3000`

### 3. Mobile App Setup

1. Navigate to the mobile_app directory:
```bash
cd mobile_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update API URL in `lib/utils/constants.dart`:
   - For Android emulator: `http://10.0.2.2:3000/api`
   - For physical device: Use your computer's IP address

4. Run the application:
```bash
flutter run
```

## API Documentation

### Base URL
```
http://localhost:3000/api
```

### Endpoints

#### 1. Get Shipment Details

**GET** `/shipments/:shipmentId`

Fetches shipment details by shipment ID.

**Parameters:**
- `shipmentId` (path parameter): The shipment tracking ID

**Response (200 OK):**
```json
{
  "success": true,
  "shipment": {
    "shipmentId": "SHIP001",
    "customerName": "Amit Kumar",
    "status": "Pending",
    "deliveredAt": null,
    "deliveredBy": null
  }
}
```

**Error Responses:**
- `404 Not Found`: Shipment not found
- `400 Bad Request`: Missing shipment ID

#### 2. Confirm Delivery

**POST** `/shipments/:shipmentId/deliver`

Confirms delivery of a shipment using OTP verification.

**Parameters:**
- `shipmentId` (path parameter): The shipment tracking ID

**Request Body:**
```json
{
  "otp": "123456",
  "deliveredBy": "agent_name"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Delivery confirmed successfully",
  "shipment": {
    "shipmentId": "SHIP001",
    "customerName": "Amit Kumar",
    "status": "Delivered"
  }
}
```

**Error Responses:**
- `400 Bad Request`: Missing required fields
- `401 Unauthorized`: Invalid OTP
- `404 Not Found`: Shipment not found
- `409 Conflict`: Shipment already delivered
- `500 Internal Server Error`: Database update failed

## Database Schema

### shipments Table

| Column Name | Type | Description |
|------------|------|-------------|
| id | INT (PK) | Unique internal ID |
| shipment_id | VARCHAR(50) | Public tracking ID |
| customer_name | VARCHAR(100) | Recipient name |
| otp_code | VARCHAR(10) | Pre-generated OTP |
| status | ENUM | 'Pending', 'In-Transit', 'Delivered' |
| delivered_at | TIMESTAMP | Delivery timestamp (NULL until delivered) |
| delivered_by | VARCHAR(100) | Delivery agent name |
| created_at | TIMESTAMP | Record creation timestamp |

## Key Features

- **OTP Verification**: Secure delivery confirmation using pre-generated OTPs
- **Data Integrity**: Prevents re-delivery of already delivered shipments
- **Asynchronous Logging**: Non-blocking logging for all delivery attempts
- **Error Handling**: Comprehensive HTTP status codes and error messages
- **RESTful API**: Clean, resource-based API design
- **Separation of Concerns**: Clear 3-tier architecture with distinct responsibilities

## Security & Data Integrity

- OTP validation at application layer
- Database-level constraint prevents duplicate deliveries
- Parameterized SQL queries prevent SQL injection
- Input validation for all API endpoints

## Observability

All delivery attempts are logged asynchronously with the following information:
- Timestamp
- Shipment ID
- Agent name
- Status (SUCCESS/FAILURE)
- Error message (if applicable)

Logs are output to console and can be extended to file-based or service-based logging.

## Testing

### Backend Testing
Use Postman or similar tool to test API endpoints:

1. **Test Get Shipment:**
   ```
   GET http://localhost:3000/api/shipments/SHIP001
   ```

2. **Test Confirm Delivery:**
   ```
   POST http://localhost:3000/api/shipments/SHIP001/deliver
   Body: {"otp": "123456", "deliveredBy": "agent1"}
   ```

### Mobile App Testing
1. Launch the app on Android emulator or device
2. Enter a shipment ID (e.g., SHIP001)
3. Click "Fetch Details"
4. Enter agent name and OTP
5. Click "Confirm Delivery"

## Test Cases Documentation

Comprehensive test cases have been thoroughly documented and manually verified to ensure system reliability and correctness. The test suite covers all critical scenarios including backend connectivity, shipment fetching, delivery confirmation, data integrity, logging, API endpoints, UI/UX, and edge cases.

All 31 test cases have been executed and verified, with detailed documentation of test steps, expected results, and actual outcomes.

[View Complete Test Cases Documentation](./TEST_CASES.md)

## AI Usage in Development

This project utilized AI assistance as a learning and development tool to bridge knowledge gaps and ensure industry-standard practices. Given limited prior experience with official industry documentation and best practices for modular, scalable code architecture, AI served as an educational resource in the following areas:

- **Best Practices Learning**: Understanding industry-standard patterns for 3-tier architecture, separation of concerns, and scalable code organization
- **Technology Stack Transition**: Translating knowledge from familiar MERN stack (MongoDB, Express, React, Node.js) to the new technology stack (MySQL, Flutter) through analogies and comparative explanations
- **Architecture Guidance**: Learning proper layered architecture patterns, including repository pattern, service layer separation, and controller responsibilities
- **Documentation**: Assistance with professional documentation structure, technical writing, and appropriate terminology for industry-standard documentation
- **Data Generation**: Generating sample shipment data for database seeding with realistic test scenarios

All code implementation, business logic, architectural decisions, and system integration were executed manually. AI functioned as a learning assistant and reference guide, helping to understand and apply best practices rather than generating code automatically.

## Future Enhancements

- OTP generation and SMS delivery integration
- Role-based access control for agents
- OTP expiry and retry limits
- Real-time delivery status updates
- Analytics dashboard for delivery metrics
- Multi-language support

## License

This project is developed as an assessment submission.

## Contact

For questions or issues, please refer to the project documentation or contact the development team.

