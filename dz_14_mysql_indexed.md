Задача - сделать полнотекстовый индекс, который ищет по свойствам, названию товара и описанию. Если нет аналогичной задачи в проекте - имитируем.
```
create fulltext index products_fulltext_index on products (name, description, properties); 
```
```
select * from products where match(name, description,properties) against('кожа' in natural language mode); 
```
План запроса с индексом и без индекса:
```
explain select * from products IGNORE index (products_fulltext_index)  where match(name, description,properties) against('кожа' in natural language mode);
1	SIMPLE	products		ALL					3	33.33	Using where
```
```
explain select * from products  where match(name, description,properties) against('кожа' in natural language mode); 
1	SIMPLE	products		fulltext	products_fulltext_index	products_fulltext_index	0	const	1	100.00	Using where; Ft_hints: sorted
```
Добавим еще несколько индексов
Индекс на customer_id в таблице orders
```
create index customer_id_idx on orders (customer_id);
explain select * from orders ignore index (customer_id_idx) where customer_id = 1;
1	SIMPLE	orders		ALL					5	100.00	Using where
```
```
explain select * from orders where customer_id = 1;
1	SIMPLE	orders		ref	customer_id_idx	customer_id_idx	5	const	5	100.00	
```
Индекс на ID статуса заказа
```
create index order_status_id_idx on orders (order_status_id);
explain select * from orders ignore index (order_status_id_idx) where order_status_id = 5;
1	SIMPLE	orders		ALL					5	100.00	Using where
explain select * from orders where order_status_id = 5;
1	SIMPLE	orders		ref	order_status_id_idx	order_status_id_idx	5	const	5	100.00	
```

Создадим уникальный индекс на email пользователя
```
create index order_status_id_idx on orders (order_status_id);
explain select * from users ignore index (unique_user_email_idx) where email = 'test@mail.ru';
1	SIMPLE	users		const	email	email	402	const	1	100.00	
explain select * from users  where email = 'test@mail.ru';
1	SIMPLE	users		const	email,unique_user_email_idx	email	402	const	1	100.00	
```

