WITH "MATCH (o:Order)<-[r:BOUGHT]-(c:Customer), (o)-[r2:ORDERED_FROM]->(b:Building), (o)<-[r3:SOLD]-(s:Staff)
RETURN o.orderId as transaction_id, o.orderDate as transaction_date, o.orderTime as transaction_time, b.buildingId as sales_outlet_id, s.staffId as staff_id, c.customerId as customer_id, o.inStore as instore_yn
ORDER BY transaction_id" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;