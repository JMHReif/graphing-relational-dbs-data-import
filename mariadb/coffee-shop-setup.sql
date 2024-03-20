CREATE DATABASE IF NOT EXISTS coffee_shop;
use coffee_shop;

CREATE TABLE IF NOT EXISTS customer(
   customer_id INT NOT NULL,
   customer_name VARCHAR(100) NOT NULL,
   customer_email VARCHAR(40) NOT NULL,
   customer_start_date DATE,
   loyalty_card_number VARCHAR(100),
   birthdate DATE,
   gender VARCHAR(10),
   birth_year VARCHAR(5),
   home_store_id VARCHAR(10),
   PRIMARY KEY ( customer_id )
);

CREATE TABLE IF NOT EXISTS product(
  product_id INT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  product_description VARCHAR(100),
  unit_of_measure VARCHAR(40),
  current_wholesale_price DECIMAL(10,2),
  current_retail_price DECIMAL(10,2),
  tax_exempt_yn VARCHAR(1),
  promo_yn VARCHAR(1),
  new_product_yn VARCHAR(1),
  type_id INT,
  PRIMARY KEY ( product_id )
);

CREATE TABLE IF NOT EXISTS product_type(
  type_id INT NOT NULL,
  product_type VARCHAR(40),
  PRIMARY KEY ( type_id )
);

CREATE TABLE IF NOT EXISTS product_category(
  category_id INT NOT NULL,
  product_category VARCHAR(40),
  group_id INT,
  PRIMARY KEY ( category_id )
);

CREATE TABLE IF NOT EXISTS type_category(
  type_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY ( type_id, category_id )
);

CREATE TABLE IF NOT EXISTS product_group(
  group_id INT NOT NULL,
  product_group VARCHAR(40),
  PRIMARY KEY ( group_id )
);

CREATE TABLE IF NOT EXISTS building(
  building_id VARCHAR(10) NOT NULL,
  building_type VARCHAR(40),
  square_feet INT,
  telephone VARCHAR(20),
  street_address VARCHAR(100),
  city VARCHAR(40),
  state_province VARCHAR(40),
  postal_code VARCHAR(20),
  longitude DECIMAL(10,6),
  latitude DECIMAL(10,6),
  neighborhood VARCHAR(40),
  manager_staff_id INT NULL,
  PRIMARY KEY ( building_id )
);

CREATE TABLE IF NOT EXISTS coffee_order(
  transaction_id INT NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_time TIME NOT NULL,
  building_id VARCHAR(10),
  staff_id INT,
  customer_id INT,
  instore_yn VARCHAR(1),
  PRIMARY KEY ( transaction_id, transaction_date, transaction_time )
);

CREATE TABLE IF NOT EXISTS order_line_item(
  transaction_id INT NOT NULL,
  transaction_date DATE NOT NULL,
  transaction_time TIME NOT NULL,
  order_number INT,
  line_item_id VARCHAR(20),
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  line_item_amount DECIMAL(10,2),
  promo_item_yn VARCHAR(1),
  PRIMARY KEY ( transaction_id, transaction_date, transaction_time, order_number, line_item_id )
);

CREATE TABLE IF NOT EXISTS staff(
  staff_id INT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  employee_start_date DATE NOT NULL,
  position VARCHAR(40),
  building_id VARCHAR(10),
  PRIMARY KEY ( staff_id )
);