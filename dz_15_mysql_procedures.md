Создать пользователей client, manager.
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры
Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи
дать права да запуск процедуры пользователю client
Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя)
с различными уровнями группировки (по товару, по категории, по производителю)
Права дать пользователю manager
```
  CREATE USER 'manager'@'localhost' IDENTIFIED BY 'password';
  CREATE USER 'client'@'localhost' IDENTIFIED BY 'password';
```
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры
drop procedure get_products;
delimiter $$
```
create  procedure get_products(_category_id int, _brand_id int, _price_from decimal, _price_to decimal)
begin
	select * from products as p
    where (_category_id is null or p.product_category_id = _category_id)
    and (_brand_id is null or p.product_brand_id = _brand_id)
	and (_price_from is null or p.price >= _price_from)
    and (_price_to is null or p.price <= _price_to);
end $$
delimiter ;

select * from products;
call get_products(null, null, 10000, 11000);

```
Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи
```
drop procedure if exists get_products2;
delimiter $$
create  procedure get_products2(_category_id int, _brand_id int, _price_from decimal, _price_to decimal, _sort_col text, _sort_type text, _limit int, _offset int)
begin
  declare category_filter varchar(255);
  declare brand_filter varchar(255);
  declare price_from_filter varchar(255);
  declare price_to_filter varchar(255);
  declare where_clause varchar(1000); 
  declare order_by varchar(1000);
  declare limit_val varchar(255);
  declare offset_val varchar(255);
  declare sql_query  varchar(1000);   
    
  if _category_id is not null then
    set @category_filter = concat('product_category_id = ', _category_id);
  end if;
  if _category_id is not null then
    set @brand_filter = concat('product_brand_id = ', _brand_id);
  end if;
  if _price_from is not null then
    set @price_from_filter = concat('price >= ', _price_from);
  end if;
  if _price_to is not null then
    set @price_to_filter = concat('price <= ', _price_to);
  end if;

  set @where_clause = concat('where ', concat_ws( ' and ', @category_filter, @brand_filter,  @price_from_filter, @price_to_filter));
        
  if _sort_col is not null then
    set @order_by = concat('order by ', _sort_col, ' ', coalesce(_sort_type, 'asc'));
  end if;
    
  if _limit is not null then
    set @limit_val = concat('limit ', _limit);
  end if;
    
  if _offset is not null then
    set @offset_val = concat('offset ', _offset);
  end if;

  set @sql_query = concat_ws (' ',
    'select * ' ,
    'from products', @where_clause, @order_by, @limit_val, @offset_val);

  prepare sql_statement from @sql_query;
  execute sql_statement;
  deallocate prepare sql_statement;
  end $$
delimiter ;
```
Запустим функцию с параметрами:
```
call get_products2(1, 3, 10000, 12000, 'price', 'desc', 3, 0);
```

Дать права да запуск процедуры пользователю client
```
grant execute on procedure shop_db.get_products2 to 'client';
```
Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя)
```
drop procedure if exists get_orders;
delimiter $$
create  procedure get_orders(_period_from timestamp, _period_to timestamp, _groupping_cols text)
begin
  declare group_by_cols varchar(255);
  declare select_cols varchar(255);
  declare period_from_filter varchar(255);
  declare period_to_filter varchar(255);
  declare sql_query  varchar(1000);   
     
	if _period_from is not null then
		set @period_from_filter = concat('o.created_at >= ', _period_from);
	end if;
  
	if _period_to is not null then
		set @period_to_filter = concat('o.created_at <= ', _period_to);
	end if;
    
  if _groupping_cols is not null then
    set @group_by_cols = concat('group by ', _groupping_cols);
    set @select_cols = concat(_groupping_cols, ', ', 'count(*) as total_count, sum(op.price * op.quantity) as total_price');
	else
    set @select_cols = ' * ';
	end if;

  set @sql_query = concat_ws (' ',
    'select ' , @select_cols, 
    'from orders as o
     inner join orders_products op on op.order_id = o.id
     inner join products as p on op.product_id = p.id
     inner join product_categories pc on pc.id = p.product_category_id', @group_by_cols);

  prepare sql_statement from @sql_query;
  execute sql_statement;
  deallocate prepare sql_statement;
  end $$
delimiter ;
```
Запросим все отчет по продажам за 2022 г. с разбивкой по категориям 
call get_orders('2022-01-01', '2022-12-31', 'pc.id'); 

Дать права да запуск процедуры пользователю manager
```
grant execute on procedure shop_db.get_orders to 'manager';
```
