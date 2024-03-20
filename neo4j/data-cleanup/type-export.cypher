WITH "MATCH (t:Type)
OPTIONAL MATCH (t)-[r2:ORGANIZED_IN]-(c:Category)
RETURN t.typeId AS type_id, t.type AS product_type, c.categoryId AS category_id" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;