# Test Cases - Last Mile Delivery System

This document outlines all test cases to verify the system functionality. Test each scenario and verify the expected results.

## Prerequisites

Before testing:
1. MySQL database is running with schema and seed data loaded
2. Backend server is running (`npm start` in backend folder)
3. Mobile app is running on Android emulator/device
4. Backend and mobile app are on same network (or using 10.0.2.2 for emulator)

---

## Test Category 1: Backend Connectivity

### TC-001: Backend Server Not Running
**Test Steps:**
1. Stop the backend server
2. Open mobile app
3. Enter Shipment ID: `SHIP001`
4. Click "Fetch Details"

**Expected Result:**
- Error message displayed: "Error: Failed to establish connection" or similar
- No shipment details shown
- App should handle error gracefully without crashing

**✅ Passed**

---

### TC-002: Backend Server Running
**Test Steps:**
1. Start the backend server (`npm start`)
2. Verify server logs show "Server running on port 3000"
3. Verify MySQL connection log shows "MySQL connected successfully"

**Expected Result:**
- Server starts without errors
- MySQL connection successful

**✅ Passed**

---

## Test Category 2: Fetch Shipment Details

### TC-003: Fetch Valid Shipment (Pending Status)
**Test Steps:**
1. Backend running
2. Enter Shipment ID: `SHIP001`
3. Click "Fetch Details"

**Expected Result:**
- Shipment details card appears
- Shows: Shipment ID: SHIP001
- Shows: Customer Name: Amit Kumar
- Shows: Status: Pending
- No error message
- Delivery confirmation section appears (since status is not Delivered)

**✅ Passed**

---

### TC-004: Fetch Valid Shipment (In-Transit Status)
**Test Steps:**
1. Enter Shipment ID: `SHIP002`
2. Click "Fetch Details"

**Expected Result:**
- Shipment details card appears
- Shows: Shipment ID: SHIP002
- Shows: Customer Name: Neha Sharma
- Shows: Status: In-Transit
- Delivery confirmation section appears

**✅ Passed**

---

### TC-005: Fetch Valid Shipment (Already Delivered)
**Test Steps:**
1. First, deliver SHIP001 using correct OTP (see TC-015)
2. Enter Shipment ID: `SHIP001`
3. Click "Fetch Details"

**Expected Result:**
- Shipment details card appears
- Shows: Status: Delivered
- Shows: Delivered By: [agent name used]
- Delivery confirmation section does NOT appear (already delivered)

**✅ Passed**

---

### TC-006: Fetch Invalid Shipment ID
**Test Steps:**
1. Enter Shipment ID: `SHIP999` (non-existent)
2. Click "Fetch Details"

**Expected Result:**
- Error message displayed: "Shipment not found"
- Error message in red box with error icon
- No shipment details shown
- Delivery confirmation section does not appear

**✅ Passed**

---

### TC-007: Fetch with Empty Shipment ID
**Test Steps:**
1. Leave Shipment ID field empty
2. Click "Fetch Details"

**Expected Result:**
- Error message: "Please enter Shipment ID"
- No API call made
- No shipment details shown

**✅ Passed**

---

### TC-008: Fetch with Special Characters
**Test Steps:**
1. Enter Shipment ID: `SHIP001' OR '1'='1` (SQL injection attempt)
2. Click "Fetch Details"

**Expected Result:**
- Error message: "Shipment not found" (not a SQL error)
- System handles safely (parameterized queries prevent injection)
- No database errors

**✅ Passed**

---

## Test Category 3: Delivery Confirmation - Validation

### TC-009: Confirm Delivery with Empty Fields
**Test Steps:**
1. Fetch valid shipment (e.g., SHIP003)
2. Leave Agent Name empty
3. Leave OTP empty
4. Click "Confirm Delivery"

**Expected Result:**
- Error message: "Please enter OTP and Agent Name"
- No API call made
- No delivery confirmation

**✅ Passed**

---

### TC-010: Confirm Delivery with Wrong OTP
**Test Steps:**
1. Fetch Shipment ID: `SHIP001` (OTP is `123456`)
2. Enter Agent Name: `agent1`
3. Enter OTP: `999999` (wrong OTP)
4. Click "Confirm Delivery"

**Expected Result:**
- Error message: "Invalid OTP"
- Error message in red box with error icon
- HTTP Status: 401 Unauthorized (check backend logs)
- Shipment status remains unchanged (check database)
- Log entry shows FAILURE status

**✅ Passed**

---

### TC-011: Confirm Delivery with Correct OTP
**Test Steps:**
1. Fetch Shipment ID: `SHIP003` (OTP is `789012`)
2. Enter Agent Name: `agent_rahul`
3. Enter OTP: `789012` (correct OTP)
4. Click "Confirm Delivery"

**Expected Result:**
- Success message: "Delivery Success!" in green box with check icon
- Shipment details refresh automatically
- Status changes to "Delivered"
- Shows "Delivered By: agent_rahul"
- Delivery confirmation section disappears
- HTTP Status: 200 OK (check backend logs)
- Log entry shows SUCCESS status
- Database shows delivered_at timestamp set

**✅ Passed**

---

### TC-012: Confirm Already Delivered Shipment
**Test Steps:**
1. Deliver SHIP001 successfully (use TC-012)
2. Fetch SHIP001 again
3. Enter Agent Name: `agent2`
4. Enter OTP: `123456` (correct OTP)
5. Click "Confirm Delivery"

**Expected Result:**
- Error message: "Shipment already delivered"
- Error message in red box
- HTTP Status: 409 Conflict (check backend logs)
- Shipment status remains "Delivered"
- Database not updated (delivered_at unchanged)
- Log entry shows FAILURE status

**✅ Passed**

---

### TC-013: Confirm Delivery with Invalid Shipment ID in URL
**Test Steps:**
1. Use Postman or similar tool
2. POST to: `http://localhost:3000/api/shipments/INVALID123/deliver`
3. Body: `{"otp": "123456", "deliveredBy": "agent1"}`

**Expected Result:**
- HTTP Status: 404 Not Found
- Response: `{"success": false, "message": "Shipment not found"}`
- No database update
- Log entry shows FAILURE status

**✅ Passed**

---

## Test Category 4: Data Integrity

### TC-014: Verify Database Update After Delivery
**Test Steps:**
1. Note current status of SHIP004 in database (should be In-Transit)
2. Deliver SHIP004 via app (OTP: `345678`)
3. Check database immediately after

**Expected Result:**
- Database shows status = 'Delivered'
- delivered_at timestamp is set (current time)
- delivered_by = agent name entered
- All fields updated correctly

**✅ Passed**

---

### TC-015: Verify Idempotency (Re-delivery Prevention)
**Test Steps:**
1. Deliver SHIP005 successfully
2. Try to deliver SHIP005 again with same OTP
3. Check database

**Expected Result:**
- Second attempt fails with "Shipment already delivered"
- Database remains unchanged (no duplicate updates)
- delivered_at timestamp unchanged
- System prevents re-delivery at both application and database level

**✅ Passed**

---

## Test Category 5: Logging Verification

### TC-016: Verify Successful Delivery Logging
**Test Steps:**
1. Deliver a shipment successfully (e.g., SHIP006)
2. Check backend console logs

**Expected Result:**
- Log entry appears: `[DELIVERY SUCCESS] [timestamp] | Shipment: SHIP006 | Agent: [name] | Delivery confirmed successfully`
- Log appears after response is sent (asynchronous)
- Log includes all required fields

**✅ Passed**

---

### TC-017: Verify Failed Delivery Logging
**Test Steps:**
1. Attempt delivery with wrong OTP
2. Check backend console logs

**Expected Result:**
- Log entry appears: `[DELIVERY FAILURE] [timestamp] | Shipment: [id] | Agent: [name] | Invalid OTP`
- Log appears after response is sent
- All failure scenarios are logged

**✅ Passed**

---

### TC-018: Verify Logging is Asynchronous
**Test Steps:**
1. Deliver a shipment
2. Observe response time in mobile app
3. Check if response is immediate

**Expected Result:**
- Response appears immediately in mobile app
- Logging happens in background (non-blocking)
- User experience is not affected by logging

**✅ Passed**

---

## Test Category 6: API Endpoint Testing (Postman)

### TC-019: GET Shipment Details - Valid ID
**Request:**
```
GET http://localhost:3000/api/shipments/SHIP001
```

**Expected Result:**
- Status: 200 OK
- Response includes shipment details (without OTP)
- JSON format correct

**✅ Passed**

---

### TC-020: GET Shipment Details - Invalid ID
**Request:**
```
GET http://localhost:3000/api/shipments/SHIP999
```

**Expected Result:**
- Status: 404 Not Found
- Response: `{"success": false, "message": "Shipment not found"}`

**✅ Passed**

---

### TC-021: POST Confirm Delivery - Success
**Request:**
```
POST http://localhost:3000/api/shipments/SHIP007/deliver
Body: {
  "otp": "234567",
  "deliveredBy": "agent_test"
}
```

**Expected Result:**
- Status: 200 OK
- Response: `{"success": true, "message": "Delivery confirmed successfully", ...}`
- Database updated

**✅ Passed**

---

### TC-022: POST Confirm Delivery - Wrong OTP
**Request:**
```
POST http://localhost:3000/api/shipments/SHIP007/deliver
Body: {
  "otp": "000000",
  "deliveredBy": "agent_test"
}
```

**Expected Result:**
- Status: 401 Unauthorized
- Response: `{"success": false, "message": "Invalid OTP"}`
- Database not updated

**✅ Passed**

---

### TC-023: POST Confirm Delivery - Missing Fields
**Request:**
```
POST http://localhost:3000/api/shipments/SHIP007/deliver
Body: {
  "otp": "234567"
}
```

**Expected Result:**
- Status: 400 Bad Request
- Response: `{"success": false, "message": "Missing required input fields"}`

**✅ Passed**

---

### TC-024: POST Confirm Delivery - Already Delivered
**Request:**
```
POST http://localhost:3000/api/shipments/SHIP001/deliver
Body: {
  "otp": "123456",
  "deliveredBy": "agent_test"
}
```
(Assuming SHIP001 is already delivered)

**Expected Result:**
- Status: 409 Conflict
- Response: `{"success": false, "message": "Shipment already delivered"}`
- Database not updated

**✅ Passed**

---

## Test Category 7: UI/UX Testing

### TC-025: Loading Indicator Display
**Test Steps:**
1. Fetch shipment details
2. Observe during API call

**Expected Result:**
- Loading spinner appears during API call
- Spinner disappears when response received
- Buttons disabled during loading

**✅ Passed**

---

### TC-026: Error Message Display
**Test Steps:**
1. Trigger any error (wrong OTP, invalid ID, etc.)

**Expected Result:**
- Error message in red box
- Error icon visible
- Message is clear and user-friendly
- Message disappears on next action

**✅ Passed**

---

### TC-027: Success Message Display
**Test Steps:**
1. Successfully deliver a shipment

**Expected Result:**
- Success message in green box
- Check icon visible
- Message: "Delivery Success!"
- Message persists until next action

**✅ Passed**

---

### TC-028: Input Field Validation
**Test Steps:**
1. Test all input fields (Shipment ID, Agent Name, OTP)
2. Try special characters, long text, etc.

**Expected Result:**
- Fields accept appropriate input
- OTP field accepts numbers
- No app crashes on invalid input
- Appropriate error messages shown

**✅ Passed**

---

## Test Category 8: Edge Cases

### TC-029: Network Interruption
**Test Steps:**
1. Start delivery confirmation
2. Disconnect network mid-request
3. Reconnect network

**Expected Result:**
- Error message shown: Connection error
- App doesn't crash
- User can retry after reconnection

**✅ Passed**

---

### TC-030: Rapid Multiple Requests
**Test Steps:**
1. Click "Fetch Details" multiple times rapidly
2. Click "Confirm Delivery" multiple times rapidly

**Expected Result:**
- No duplicate processing
- Only one request processed
- App handles gracefully
- No race conditions

**✅ Passed**

---

### TC-031: Very Long Input Values
**Test Steps:**
1. Enter very long shipment ID (100+ characters)
2. Enter very long agent name (100+ characters)

**Expected Result:**
- System handles gracefully
- Appropriate validation/error messages
- No crashes or database errors.

**✅ Passed**
---