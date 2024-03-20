WITH "MATCH (o:Order)-[r:CONTAINS]->(p:Product)
RETURN o.transactionId as transaction_id, o.transactionDate as transaction_date, o.transactionTime as transaction_time, r.order as order, r.lineItem as line_item_id, p.productId as product_id, r.quantity as quantity, r.itemTotal as line_item_amount, r.unitPrice as unit_price, r.promo as promo_item_yn
ORDER BY transaction_id" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;