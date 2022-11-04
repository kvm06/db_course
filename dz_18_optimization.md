 Возьмем следлующий запрос из ДЗ №10. Посчитать товары категории "Обувь", которые заканчиваются на слкаде. 
 Усложним запрос, чтобы также выводилась информация о количестве проданных товаров в текущем году. 
 ```
select * from orders_products;select p.id, p.name, count(*) as count_in_stock,
    (select count(*) 
    from orders_products op_inn
    inner join orders o_inn on op_inn.order_id = o_inn.id
    where op_inn.product_id = p.id
    and o_inn.created_at >= '2022-01-01') as selled_in_2022
  from products_in_stock as ps
  inner join products p on p.id = ps.product_id
  where product_category_id = 1 and ps.quantity <= 10;
  ```
  
Построим план запроса
```
explain select p.id, p.name, count(*) as count_in_stock,
    (select count(*) 
    from orders_products op_inn
    inner join orders o_inn on op_inn.order_id = o_inn.id
    where op_inn.product_id = p.id
    and o_inn.created_at >= '2022-01-01') as selled_in_2022
  from products_in_stock as ps
  inner join products p on p.id = ps.product_id
  where product_category_id = 1 and ps.quantity <= 10;
```

# id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
1	PRIMARY	p		ALL	PRIMARY				3	33.33	Using where
1	PRIMARY	ps		ALL					991	3.33	Using where; Using join buffer (hash join)
2	DEPENDENT SUBQUERY	op_inn		ALL					10976	10.00	Using where
2	DEPENDENT SUBQUERY	o_inn		eq_ref	PRIMARY	PRIMARY	4	shop_db.op_inn.order_id	1	33.33	Using where

Построим план запроса в виде JSON
```
explain  format=json select p.id, p.name, count(*) as count_in_stock,
    (select count(*) 
    from orders_products op_inn
    inner join orders o_inn on op_inn.order_id = o_inn.id
    where op_inn.product_id = p.id
    and o_inn.created_at >= '2022-01-01') as selled_in_2022
  from products_in_stock as ps
  inner join products p on p.id = ps.product_id
  where product_category_id = 1 and ps.quantity <= 10;
```

```План запроса в JSON-формате
# EXPLAIN
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "100.91"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "p",
          "access_type": "ALL",
          "possible_keys": [
            "PRIMARY"
          ],
          "rows_examined_per_scan": 3,
          "rows_produced_per_join": 1,
          "filtered": "33.33",
          "cost_info": {
            "read_cost": "0.45",
            "eval_cost": "0.10",
            "prefix_cost": "0.55",
            "data_read_per_join": "1K"
          },
          "used_columns": [
            "id",
            "name",
            "product_category_id"
          ],
          "attached_condition": "(`shop_db`.`p`.`product_category_id` = 1)"
        }
      },
      {
        "table": {
          "table_name": "ps",
          "access_type": "ALL",
          "rows_examined_per_scan": 991,
          "rows_produced_per_join": 33,
          "filtered": "3.33",
          "using_join_buffer": "hash join",
          "cost_info": {
            "read_cost": "67.33",
            "eval_cost": "3.30",
            "prefix_cost": "100.91",
            "data_read_per_join": "1K"
          },
          "used_columns": [
            "product_id",
            "quantity"
          ],
          "attached_condition": "((`shop_db`.`ps`.`product_id` = `shop_db`.`p`.`id`) and (`shop_db`.`ps`.`quantity` <= 10))"
        }
      }
    ],
    "select_list_subqueries": [
      {
        "dependent": true,
        "cacheable": false,
        "query_block": {
          "select_id": 2,
          "cost_info": {
            "query_cost": "1488.51"
          },
          "nested_loop": [
            {
              "table": {
                "table_name": "op_inn",
                "access_type": "ALL",
                "rows_examined_per_scan": 10976,
                "rows_produced_per_join": 1097,
                "filtered": "10.00",
                "cost_info": {
                  "read_cost": "6.75",
                  "eval_cost": "109.76",
                  "prefix_cost": "1104.35",
                  "data_read_per_join": "25K"
                },
                "used_columns": [
                  "order_id",
                  "product_id"
                ],
                "attached_condition": "((`shop_db`.`op_inn`.`product_id` = `shop_db`.`p`.`id`) and (`shop_db`.`op_inn`.`order_id` is not null))"
              }
            },
            {
              "table": {
                "table_name": "o_inn",
                "access_type": "eq_ref",
                "possible_keys": [
                  "PRIMARY"
                ],
                "key": "PRIMARY",
                "used_key_parts": [
                  "id"
                ],
                "key_length": "4",
                "ref": [
                  "shop_db.op_inn.order_id"
                ],
                "rows_examined_per_scan": 1,
                "rows_produced_per_join": 365,
                "filtered": "33.33",
                "cost_info": {
                  "read_cost": "274.40",
                  "eval_cost": "36.58",
                  "prefix_cost": "1488.51",
                  "data_read_per_join": "11K"
                },
                "used_columns": [
                  "id",
                  "created_at"
                ],
                "attached_condition": "(`shop_db`.`o_inn`.`created_at` >= TIMESTAMP'2022-01-01 00:00:00')"
              }
            }
          ]
        }
      }
    ]
  }
}


```
Построим план запроса в виде дерева
```
explain analyze format=tree select p.id, p.name, count(*) as count_in_stock,
    (select count(*) 
    from orders_products op_inn
    inner join orders o_inn on op_inn.order_id = o_inn.id
    where op_inn.product_id = p.id
    and o_inn.created_at >= '2022-01-01') as selled_in_2022
  from products_in_stock as ps
  inner join products p on p.id = ps.product_id
  where product_category_id = 1 and ps.quantity <= 10;
```

``` План запроса в виде дерева
# EXPLAIN
-> Aggregate: count(0)  (cost=71.30 rows=1) (actual time=1.083..1.083 rows=1 loops=1)
    -> Inner hash join (ps.product_id = p.id)  (cost=71.19 rows=1) (actual time=0.154..1.074 rows=8 loops=1)
        -> Filter: (ps.quantity <= 10)  (cost=70.64 rows=33) (actual time=0.054..0.934 rows=112 loops=1)
            -> Table scan on ps  (cost=70.64 rows=991) (actual time=0.053..0.790 rows=991 loops=1)
        -> Hash
            -> Filter: (p.product_category_id = 1)  (cost=0.55 rows=1) (actual time=0.068..0.077 rows=2 loops=1)
                -> Table scan on p  (cost=0.55 rows=3) (actual time=0.066..0.075 rows=3 loops=1)
-> Select #2 (subquery in projection; dependent)
    -> Aggregate: count(0)  (cost=537.25 rows=1) (actual time=58.849..58.849 rows=1 loops=1)
        -> Nested loop inner join  (cost=500.67 rows=366) (actual time=0.077..58.715 rows=764 loops=1)
            -> Filter: ((op_inn.product_id = p.id) and (op_inn.order_id is not null))  (cost=116.51 rows=1098) (actual time=0.038..21.973 rows=10982 loops=1)
                -> Table scan on op_inn  (cost=116.51 rows=10976) (actual time=0.034..19.245 rows=10985 loops=1)
            -> Filter: (o_inn.created_at >= TIMESTAMP'2022-01-01 00:00:00')  (cost=0.25 rows=0.3) (actual time=0.003..0.003 rows=0 loops=10982)
                -> Single-row index lookup on o_inn using PRIMARY (id=op_inn.order_id)  (cost=0.25 rows=1) (actual time=0.002..0.002 rows=1 loops=10982)

  
Слабые места в данном запросе - Table scan по таблицам orders_products и products
Добавим индексы на соответствующие поля. 
```
create index product_category_id_idx on products (product_category_id)

create index product_id_idx on orders_products (product_id);
```
И проверим план запроса еще раз
explain analyze format=tree select p.id, p.name, count(*) as count_in_stock,
    (select count(*) 
    from orders_products op_inn
    inner join orders o_inn on op_inn.order_id = o_inn.id
    where op_inn.product_id = p.id
    and o_inn.created_at >= '2022-01-01') as selled_in_2022
  from products_in_stock as ps
  inner join products p on p.id = ps.product_id
  where product_category_id = 1 and ps.quantity <= 10;

# EXPLAIN
-> Aggregate: count(0)  (cost=75.12 rows=1) (actual time=1.184..1.184 rows=1 loops=1)
    -> Inner hash join (ps.product_id = p.id)  (cost=74.90 rows=2) (actual time=0.157..1.173 rows=8 loops=1)
        -> Filter: (ps.quantity <= 10)  (cost=35.45 rows=33) (actual time=0.066..1.036 rows=112 loops=1)
            -> Table scan on ps  (cost=35.45 rows=991) (actual time=0.064..0.827 rows=991 loops=1)
        -> Hash
            -> Index lookup on p using product_category_id_idx (product_category_id=1)  (cost=0.70 rows=2) (actual time=0.062..0.067 rows=2 loops=1)
-> Select #2 (subquery in projection; dependent)
    -> Aggregate: count(0)  (cost=2672.77 rows=1) (actual time=71.533..71.533 rows=1 loops=1)
        -> Nested loop inner join  (cost=2489.85 rows=1829) (actual time=0.108..71.388 rows=764 loops=1)
            -> Filter: (op_inn.order_id is not null)  (cost=569.05 rows=5488) (actual time=0.076..34.608 rows=10982 loops=1)
                -> Index lookup on op_inn using product_id_idx (product_id=p.id)  (cost=569.05 rows=5488) (actual time=0.074..32.785 rows=10982 loops=1)
            -> Filter: (o_inn.created_at >= TIMESTAMP'2022-01-01 00:00:00')  (cost=0.25 rows=0.3) (actual time=0.003..0.003 rows=0 loops=10982)
                -> Single-row index lookup on o_inn using PRIMARY (id=op_inn.order_id)  (cost=0.25 rows=1) (actual time=0.002..0.002 rows=1 loops=10982)

Как мы видим,  оба индекса применились.
