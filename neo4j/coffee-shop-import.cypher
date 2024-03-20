//Total loaded data size:
//6,646 nodes
//68,039 relationships

CREATE CONSTRAINT FOR (p:Product) REQUIRE p.productId IS UNIQUE;
CREATE CONSTRAINT FOR (c:Customer) REQUIRE c.customerId IS UNIQUE;
CREATE CONSTRAINT FOR (b:Building) REQUIRE b.buildingId IS UNIQUE;
CREATE CONSTRAINT FOR (s:Staff) REQUIRE s.staffId IS UNIQUE;
CREATE CONSTRAINT FOR (o:Order) REQUIRE (o.orderId, o.orderDate, o.orderTime) IS NODE KEY;

//Load products, types, categories, groups
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/JMHReif/graph-demo-datasets/main/coffee-shop/product.csv" AS row
WITH row
CALL { 
    WITH row
    MERGE (p:Product {productId: toInteger(row.product_id)})
     SET p.productName = row.product,
        p.productDescription = row.product_description,
        p.unitOfMeasure = row.unit_of_measure,
        p.wholesalePrice = toFloat(row.current_wholesale_price),
        p.retailPrice = toFloat(trim(substring(row.current_retail_price,1))),
        p.taxExempt = row.tax_exempt_yn,
        p.promo = row.promo_yn,
        p.newProduct = row.new_product_yn
    RETURN p
}
WITH row, p
CALL {
    WITH row
    MATCH (p:Product {productId: toInteger(row.product_id)})
    MERGE (t:Type {type: row.product_type})
    MERGE (p)-[r:SORTED_BY]->(t)
}
WITH row, p
CALL {
    WITH row
    MATCH (t:Type {type: row.product_type})
    MERGE (c:Category {category: row.product_category})
    MERGE (t)-[r:ORGANIZED_IN]->(c)
}
WITH row, p
CALL {
    WITH row
    MATCH (c:Category {category: row.product_category})
    MERGE (g:Group {group: row.product_group})
    MERGE (c)-[r:PART_OF]->(g)
}
RETURN count(p);

//Load buildings
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/JMHReif/graph-demo-datasets/main/coffee-shop/sales_outlet.csv" AS row
MERGE (b:Building {buildingId: toInteger(row.sales_outlet_id)})
ON CREATE SET b.type = row.sales_outlet_type,
    b.squareFeet = toInteger(row.store_square_feet),
    b.address = row.store_address,
    b.city = row.store_city,
    b.region = row.store_state_province,
    b.telephone = row.store_telephone,
    b.postalCode = row.store_postal_code,
    b.longitude = toFloat(row.store_longitude),
    b.latitude = toFloat(row.store_latitude),
    b.neighborhood = row.Neighborhood
WITH row, b
WHERE row.manager IS NOT NULL
MERGE (m:Staff {staffId: toInteger(row.manager)})
MERGE (m)-[r:MANAGES]->(b)
RETURN count(b);

//Load customers
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/JMHReif/graph-demo-datasets/main/coffee-shop/customer.csv" AS row
MERGE (c:Customer {customerId: toInteger(row.customer_id)})
ON CREATE SET c.name = row.`customer_first-name`,
    c.email = row.customer_email,
    c.entryDate = date(row.customer_since),
    c.loyaltyCardNumber = row.loyalty_card_number,
    c.birthdate = date(row.birthdate),
    c.gender = row.gender,
    c.birthyear = row.birth_year
WITH row, c
MERGE (b:Building {buildingId: toInteger(row.home_store)})
MERGE (c)-[r:HAS_HOME_STORE]->(b)
RETURN count(c);

//Load staff
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/JMHReif/graph-demo-datasets/main/coffee-shop/staff.csv" AS row
MERGE (s:Staff {staffId: toInteger(row.staff_id)})
 SET s.firstName = row.first_name,
    s.lastName = row.last_name,
    s.position = row.position,
    s.startDate = date(apoc.date.convertFormat(row.start_date, 'M/d/yyyy', 'iso_date'))
WITH row, s
MATCH (b:Building {buildingId: toInteger(row.location)})
MERGE (s)-[r:WORKS_IN]->(b)
RETURN count(s);

//Load sales receipts
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/JMHReif/graph-demo-datasets/main/coffee-shop/sales_receipts.csv" AS row
CALL {
    WITH row
    MERGE (o:Order {orderId: toInteger(row.transaction_id), orderDate: date(row.transaction_date), orderTime: localtime(row.transaction_time)})
    ON CREATE SET o.inStore = row.instore_yn
    WITH row, o
    CALL {
        WITH row, o
        MATCH (p:Product {productId: toInteger(row.product_id)})
        MERGE (o)-[r:CONTAINS]->(p)
        SET r.order = toInteger(row.order),
         r.lineItem = toInteger(row.line_item_id),
         r.quantity = toInteger(row.quantity),
         r.itemTotal = toFloat(row.line_item_amount),
         r.unitPrice = toFloat(row.unit_price),
         r.promo = row.promo_item_yn
    }
    WITH row, o
    CALL {
        WITH row, o
        MATCH (b:Building {buildingId: toInteger(row.sales_outlet_id)})
        MERGE (o)-[r:ORDERED_FROM]->(b)
    }
    WITH row, o
    CALL {
        WITH row, o
        MATCH (s:Staff {staffId: toInteger(row.staff_id)})
        MERGE (o)<-[r:SOLD]-(s)
    }
    WITH row, o
    CALL {
        WITH row, o
        MATCH (c:Customer {customerId: toInteger(row.customer_id)})
        MERGE (c)-[r:BOUGHT]->(o)
    }
} IN TRANSACTIONS OF 5000 ROWS;