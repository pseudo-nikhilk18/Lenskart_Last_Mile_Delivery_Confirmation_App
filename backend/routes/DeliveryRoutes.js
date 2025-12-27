const express = require('express');
const router = express.Router();
const deliveryController = require('../controllers/DeliveryController');

router.get('/shipments/:shipmentId', deliveryController.getShipmentDetails);

router.post('/shipments/:shipmentId/deliver', deliveryController.confirmDelivery);

module.exports = router;

