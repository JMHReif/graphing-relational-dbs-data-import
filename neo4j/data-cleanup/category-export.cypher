WITH "MATCH (c:Category)
OPTIONAL MATCH (c)-[r2:PART_OF]-(g:Group)
RETURN c.categoryId AS category_id, c.category AS product_category, g.groupId AS group_id" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;