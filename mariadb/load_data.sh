#! /bin/bash
#mysqladmin -uroot -pTesting123 create coffee_shop
mariadb -uroot -pTesting123 -s < coffee-shop-setup.sql

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
 LOAD DATA LOCAL INFILE 'customer.csv' INTO TABLE customer
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (customer_id, home_store_id, customer_name, customer_email, customer_start_date, loyalty_card_number, birthdate, gender, birth_year);
 SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'product.csv' INTO TABLE product
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'product_type.csv' INTO TABLE product_type
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'product_category.csv' INTO TABLE product_category
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'type_category_rels.csv' INTO TABLE type_category
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'product_group.csv' INTO TABLE product_group
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'sales_outlet.csv' INTO TABLE building
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (building_id, building_type, square_feet, street_address, city, state_province, telephone, postal_code, longitude, latitude, manager_staff_id, neighborhood);
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'order.csv' INTO TABLE coffee_order
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'order-lineitem.csv' INTO TABLE order_line_item
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (transaction_id, transaction_date, transaction_time, order_number, line_item_id, product_id, quantity, line_item_amount, unit_price, promo_item_yn);
SHOW WARNINGS;
SQL

mariadb -uroot -pTesting123 -D coffee_shop <<SQL
LOAD DATA LOCAL INFILE 'staff.csv' INTO TABLE staff
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES
 (staff_id, first_name, last_name, position, @startDate, building_id)
 SET employee_start_date = STR_TO_DATE(@startDate, '%m/%d/%Y');
SHOW WARNINGS;
SQL