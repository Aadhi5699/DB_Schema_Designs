1 User opens product page

2 Product details loaded from MySQL + Redis cache

3 Inventory availability loaded from Redis

4 User adds item to cart

5 Redis reservation created
   SET stock_lock:sku123:user456 qty=2 NX EX 600

6 Stock becomes RESERVED in UI

7 User proceeds to checkout

8 Address + shipping charges loaded

9 Payment started

10 Payment success

11 Verify Redis reservation belongs to user

12 Create order record

13 Create order_items records
   (supports multi-vendor split orders)

14 Update inventory table → deduct stock

15 Remove Redis reservation

16 Create payment record

17 Create vendor settlement entries

18 Publish event
   {
     "event": "ORDER_CONFIRMED",
     "order_id": "o123",
     "user_id": "u45",
     "vendors": ["v12","v78"],
     "items": [
       {"sku":"sku123","qty":2},
       {"sku":"sku789","qty":1}
     ],
     "amount": 2499
   }

19 Message queue receives event

order-events
     |
     ├> Email Service
     ├> SMS / WhatsApp Service
     ├> Invoice Service
     ├> Warehouse / Fulfillment Service
     ├> Vendor Notification Service
     ├> Loyalty / Rewards Service
     └> Analytics Service


----------------------------------------
FAILURE / CLEANUP FLOWS
----------------------------------------

A. Payment Failed / User Closed Tab

1 Reservation key still exists temporarily

2 Cleanup Worker runs:
   - checks expired / failed payments
   - deletes reserve:sku123:user456
   - increments Redis stock back

3 Product becomes available again


B. DB Failure During Order Creation

1 Any failure in Steps 13–18

2 ROLLBACK TRANSACTION

3 No partial order / no partial payment / no partial stock deduction


C. Duplicate Payment Webhook

1 Gateway sends success twice

2 Idempotency check detects payment_id already processed

3 Skip duplicate order creation
