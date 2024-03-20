WITH "MATCH (p:Product)
OPTIONAL MATCH (p)-[r:SORTED_BY]->(t:Type)-[r2:ORGANIZED_IN]-(c:Category)-[r3:PART_OF]->(g:Group)
RETURN p.productId as product_id, p.productName AS product, p.productDescription AS product_description, 
 p.unitOfMeasure AS unit_of_measure, p.wholesalePrice AS current_wholesale_price, p.retailPrice AS current_retail_price, 
 p.taxExempt AS tax_exempt_yn, p.promo AS promo_yn, p.newProduct AS new_product_yn, t.typeId AS type_id 
 ORDER BY product_id" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;