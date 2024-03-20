WITH "MATCH (g:Group)
RETURN g.groupId AS group_id, g.group AS product_group" AS query
CALL apoc.export.csv.query(query, null, {stream: true, quotes: 'none'})
YIELD data
RETURN data;