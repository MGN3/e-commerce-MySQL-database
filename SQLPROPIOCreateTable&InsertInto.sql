CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(40) NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(30) NOT NULL,
    administrative_division VARCHAR(50) NOT NULL,
    postal_code INT(15) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    user_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(255) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE Customer_Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_cost DECIMAL(10,2) NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE Carts (
    cart_id INT NOT NULL,
    item_cart_id INT NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES Customer_Orders(order_id),
    FOREIGN KEY (item_cart_id) REFERENCES Items(item_id)
);

CREATE TABLE Payments (
    payment_id INT NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'net_banking', 'wallet', 'cod') NOT NULL,
    payment_status ENUM('pending', 'success', 'failed') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES Customer_Orders(order_id)
);

CREATE TABLE Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_review_id INT NOT NULL,
    item_review_id INT NOT NULL,
    rating INT NOT NULL CHECK('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'),
    review_text TEXT NULL,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_review_id) REFERENCES Users(user_id),
    FOREIGN KEY (item_review_id) REFERENCES Items(item_id)
);


-----

INSERT INTO Users (username, password, email, first_name, last_name, address, city, administrative_division, postal_code, phone)
VALUES 
('jjuan', 'mypassword', 'juan@test.com', 'Juan', 'Pérez', 'Calle República 123', 'Madrid', 'Comunidad de Madrid', '28000', '+34123456789'),
('mmaria', 'mypassword1', 'maria@test.com', 'Maria', 'García', 'Calle Grande 321', 'Barcelona', 'Cataluña', '27000', '+34987654321'),
('ppepe', 'mypassword2', 'pepe@test.com', 'Pedro', 'Sánchez', 'Avenida Gran Via 312', 'Sevilla', 'Andalucía', '26000', '+34666666666'),
('llola', 'mypassword3', 'lola@test.com', 'Lola', 'Martínez', 'Calle Piedad 213', 'Toledo', 'Castilla-La Mancha', '25000', '+34612345678'),
('ccarlos', 'mypassword4', 'carlos@test.com', 'Carlos', 'Gil', 'Calle Perdón 111', 'Ourense', 'Galicia', '24000', '+34698765432'),
('ccarla', 'mypassword5', 'carla@test.com', 'Carla', 'García', 'Calle Perdón 111', 'Ourense', 'Galicia', '24000', '+34698765431'),
('ssara', 'mypassword6', 'sara@test.com', 'Sara', 'Pérez', 'Calle Perdón 100', 'Ourense', 'Galicia', '24000', '+34698765420');

INSERT INTO Items (name, price, category, stock)
VALUES 
('Artichokes', 2.00, 'Vegetable', 80),
('Potatoes', 0.90, 'Tuber', 500),
('Corn', 1.00, 'Grain', 200),
('Chickpea', 0.80, 'Legume', 300),
('Almond', 20.00, 'Seed', 30),
('Hazelnut', 25.00, 'Seed', 20),
('Lentils', 1.00, 'Legume', 200);

INSERT INTO Customer_Orders (customer_id, total_cost, shipping_address, order_status)
VALUES 
(1, 47.00, 'Calle República 123, Madrid, Madrid, 28000', 'pending'),
(2, 38.00, 'Calle Grande 321, Barcelona, Cataluña, 27000', 'processing'),
(3, 70.00, 'Avenida Gran Via 312, Sevilla, Andalucía, 26000', 'shipped'),
(4, 46.00, 'Calle Piedad 213, Toledo, Castilla-La Mancha, 25000', 'delivered'),
(5, 140.00, 'Calle Perdón 111, Ourense, Galicia, 24000', 'cancelled'),
(5, 140.00, 'Calle Perdón 111, Ourense, Galicia, 24000', 'processing'),
(7, 330.00, 'Calle Perdón 100, Ourense, Galicia, 24000', 'pending');

INSERT INTO Carts (cart_id, item_cart_id, quantity)
VALUES 
(1, 1, 10.00), 
(1, 2, 30.00),
(2, 2, 20.00),
(2, 3, 20.00),
(3, 3, 20.00),
(3, 4, 50.00),
(4, 4, 20.00),
(4, 5, 1.50),
(5, 4, 50.00),
(5, 5, 5.00),
(6, 4, 50.00),
(6, 5, 5.00),
(7, 3, 50.00),
(7, 4, 50.00),
(7, 5, 5.00),
(7, 6, 5.00),
(7, 7, 15.00);

INSERT INTO Payments (payment_id, payment_method, payment_status, amount)
VALUES 
(1, 'credit_card', 'success', 47.00),
(2, 'debit_card', 'success', 38.00),
(3, 'net_banking', 'success', 70.00),
(4, 'wallet', 'pending', 46.00),
(5, 'cod', 'failed', 140.00),
(6, 'credit_card', 'success', 140.00),
(7, 'credit_card', 'success', 330.00);


INSERT INTO Reviews (user_review_id, item_review_id, rating, review_text)
VALUES 
(1, 1, 9, 'Artichokes are premium quality, perfect for premium restaurants and chefs.'),
(2, 2, 10, 'Many people understimate the importance of the potatoes quality, these "white" potatoes are really good, soft and tasty.'),
(3, 3, 3, 'I didnt like the corn, its not as good as one would expect considering the price.'),
(4, 4, 8, 'Spanish chickpeas basically rock it.'),
(6, 5, 5, 'Good almonds, but in my last order some of them were rotten... just a few, but I had to check them all.'),
(7, 3, 6, 'average'),
(7, 4, 10, ''),
(7, 5, 7, 'Good but they were even better previously.'),
(7, 6, 8, 'Even beter than almonds.'),
(7, 7, 10, 'If you want to sell a good product in you own store, get your legumes here.');