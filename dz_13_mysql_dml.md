предоставить следующий результат
группировки с ипользованием CASE, HAVING, ROLLUP, GROUPING():
для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений
также сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории
сделать rollup с количеством товаров по категориям

группировки с ипользованием CASE, HAVING, ROLLUP, GROUPING():
Выберем товары, которые 

Добавим еще несколько записей и посчитаем маржинальность товаров (сколько общей прибыли принесли продажи каждого товара).
Условно будем считать, что маржинальность >= 50% высокая, от 30 до 50 средняя, от 10 до 30 низкая. 
```
select p.id, 100 - (sum(sp.price * op.quantity)/sum(op.price * op.quantity) * 100) as marginality,
	case when 100 - (sum(sp.price * op.quantity)/sum(op.price * op.quantity) * 100) >= 50 then 'Высокая'
		 when 100 - (sum(sp.price * op.quantity)/sum(op.price * op.quantity) * 100) >= 30 then 'Средняя'
         when 100 - (sum(sp.price * op.quantity)/sum(op.price * op.quantity) * 100) >= 10 then 'Низкая'
	 end as marginality_category 
from products as p
left join suppliers_pricelists as sp on sp.product_id = p.id 
left join orders_products as op on op.product_id = p.id
left join orders as o on o.id = op.order_id
left join order_statuses os on os.id = o.order_status_id
where os.status_name = 'Выполнен'
group by p.id
having 100 - (sum(sp.price * op.quantity)/sum(op.price * op.quantity) * 100) >= 10
order by marginality desc;
```
Вывод: 
3	50.0000	Высокая
2	20.0000	Низкая
1	18.1818	Низкая

Посчитаем общую прибыль по годам+ категориям с помощью ROLLUP
```
select 
	IF(GROUPING(YEAR(o.created_at)), 'Total in year', YEAR(o.created_at)) as order_year,
	pc.id  as category_id,
	sum(op.price * op.quantity) as total_income
from products as p
inner join product_categories as pc on pc.id = p.product_category_id
left join orders_products as op on op.product_id = p.id
left join orders o on o.id = op.order_id
group by YEAR(o.created_at), category_id with rollup;
```

для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений
```
select 
	p.id as product_id, 
	min(op.price), 
	max(op.price) 
from products as p
left join orders_products op on op.product_id = p.id
group by p.id;
```

также сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории
```
select 
	pc.id  as category_id,
	min(p.price) as min_price, 
	max(p.price) as max_price
from products as p
inner join product_categories as pc on pc.id = p.product_category_id
group by pc.id; 
```

сделать rollup с количеством товаров по категориям
```
select 
	pc.id  as category_id,
	count(p.id) as products_in_category
from products as p
inner join product_categories as pc on pc.id = p.product_category_id
group by pc.id with rollup;
```
