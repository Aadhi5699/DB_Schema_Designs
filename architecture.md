1 User opens show

2 Seat map loaded from Redis

3 User selects seats

4 Redis lock created
   SET seat_lock:show123:A1 user456 NX EX 300

5 Seat becomes LOCKED in UI

6 Payment started

7 Payment success

8 Verify Redis lock belongs to user

9 Create booking record

10 Update show_seats table → BOOKED

11 Remove Redis lock

12 Publish event
   {
     "event": "BOOKING_CONFIRMED",
     "booking_id": "b123",
     "user_id": "u45",
     "show_id": "show1",
     "seats": ["A1","A2"]
   }

13 Message queue receives event

booking-events
     |
     ├> Email Service
     ├> SMS Service
     ├> Invoice Service
     └> Analytics Service
