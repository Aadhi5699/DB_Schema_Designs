1 User opens show

2 Seat map loaded (from cache)

3 User selects seats

4 Redis lock created  (SET seat_lock:show123:A1 user456 NX EX 300)

5 Seats marked LOCKED

6 Payment started

7 Payment success
      |
      v
8 Booking created

9 DB seat status → BOOKED

10 Redis lock removed
