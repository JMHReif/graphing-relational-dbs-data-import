//Add unique id fields to Type, Category, and Group nodes
//This is for unique technical keys for exporting CSV files for relational db import

MATCH (t:Type)
WITH collect(t.type) AS types
WITH types, range(0, size(types) - 1) AS ordinal_positions
UNWIND ordinal_positions AS id
WITH id+1 as type_id, types[id] as typeName
MATCH (ty:Type {type: typeName})
SET ty.typeId = type_id
RETURN ty;

MATCH (c:Category)
WITH collect(c.category) AS categories
WITH categories, range(0, size(categories) - 1) AS ordinal_positions
UNWIND ordinal_positions AS id
WITH id+1 as category_id, categories[id] as categoryName
MATCH (ca:Category {category: categoryName})
 SET ca.categoryId = category_id
RETURN ca;

MATCH (g:Group)
WITH collect(g.group) AS groups
WITH groups, range(0, size(groups) - 1) AS ordinal_positions
UNWIND ordinal_positions AS id
WITH id+1 as group_id, groups[id] as groupName
MATCH (gr:Group {group: groupName})
 SET gr.groupId = group_id
RETURN gr;