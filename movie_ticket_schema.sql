-- =========================================================
-- Movie Ticket Booking Database Schema
-- =========================================================

-- USERS
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- MOVIES
CREATE TABLE movies (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    language VARCHAR(50),
    duration_minutes INT,
    release_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- THEATRES
CREATE TABLE theatres (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- SCREENS (Each theatre can have multiple screens)
CREATE TABLE screens (
    id UUID PRIMARY KEY,
    theatre_id UUID NOT NULL,
    screen_name VARCHAR(50),
    total_seats INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_theatre
        FOREIGN KEY(theatre_id)
        REFERENCES theatres(id)
);


-- SEATS (Seat layout per screen)
CREATE TABLE seats (
    id UUID PRIMARY KEY,
    screen_id UUID NOT NULL,
    row_label VARCHAR(5),
    seat_number INT,
    seat_type VARCHAR(20), -- REGULAR / PREMIUM / RECLINER

    CONSTRAINT fk_screen
        FOREIGN KEY(screen_id)
        REFERENCES screens(id)
);


-- SHOWS (Movie showtime)
CREATE TABLE shows (
    id UUID PRIMARY KEY,
    movie_id UUID NOT NULL,
    screen_id UUID NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    base_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_movie
        FOREIGN KEY(movie_id)
        REFERENCES movies(id),

    CONSTRAINT fk_show_screen
        FOREIGN KEY(screen_id)
        REFERENCES screens(id)
);


-- SHOW SEATS (Seat availability for each show)
CREATE TABLE show_seats (
    id UUID PRIMARY KEY,
    show_id UUID NOT NULL,
    seat_id UUID NOT NULL,
    status VARCHAR(20) DEFAULT 'AVAILABLE',
    locked_at TIMESTAMP,

    CONSTRAINT fk_show
        FOREIGN KEY(show_id)
        REFERENCES shows(id),

    CONSTRAINT fk_seat
        FOREIGN KEY(seat_id)
        REFERENCES seats(id)
);


-- BOOKINGS
CREATE TABLE bookings (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    show_id UUID NOT NULL,
    total_amount DECIMAL(10,2),
    status VARCHAR(20), -- PENDING / CONFIRMED / CANCELLED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(id),

    CONSTRAINT fk_booking_show
        FOREIGN KEY(show_id)
        REFERENCES shows(id)
);


-- BOOKING SEATS (Multiple seats per booking)
CREATE TABLE booking_seats (
    id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    show_seat_id UUID NOT NULL,
    price DECIMAL(10,2),

    CONSTRAINT fk_booking
        FOREIGN KEY(booking_id)
        REFERENCES bookings(id),

    CONSTRAINT fk_show_seat
        FOREIGN KEY(show_seat_id)
        REFERENCES show_seats(id)
);


-- PAYMENTS
CREATE TABLE payments (
    id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    amount DECIMAL(10,2),
    payment_time TIMESTAMP,

    CONSTRAINT fk_payment_booking
        FOREIGN KEY(booking_id)
        REFERENCES bookings(id)
);


-- =========================================================
-- INDEXES (Performance Optimization)
-- =========================================================

CREATE INDEX idx_movie_id ON shows(movie_id);
CREATE INDEX idx_screen_id ON shows(screen_id);
CREATE INDEX idx_show_id ON show_seats(show_id);
CREATE INDEX idx_user_booking ON bookings(user_id);
CREATE INDEX idx_booking_id ON booking_seats(booking_id);
