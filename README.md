# db_course
База данных для интернет-магазина одежды и обуви. 

# Описание таблиц и полей базы данных
# customers - покупатели
    id - id покупателя  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    first_name - имя покупателя, указанное при регистрации  
    last_name - фамилия покупателя, указанная при регистрации  
    phone - номер телефона  
    email - email  
    password_hash - hash пароля  
    address - адрес пользователя  

# products 
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    name - название товара  
    description  - описание товара  
    price - цена продажи товара  
    product_category_id - id категории товара  
    product_type_id - id типа товара  
    priduct_brand_id - id бренда товара  
    product_season_id - id сезона товара  
    product_color_id - id цвета товара  
    avg_raiting - средний рейтинг товара, по оценкам покупателей. Обновляется с помощью триггера при добавлении оценки  
    available_sizes array - возможные размеры товара (размеры товаров в наличии хранятся в таблице products_in_stock)  

# products_photos - фото товаров, хранятся в виде ссылок на файлы
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    product_id - id товара  
    url - ссылка на фото  

# product_categories - категории товаров (мужская, женская, детская)
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    category_name - название категории  
    photo varchar(100) - фото категории  

# product_seasons - сезоны (летняя, зимняя, демисезонная)
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    season_name - название сезона  

# product_brands - бренды товара (Adidas, Puma..)
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    brand_name - название бренда  

# product_colors - цвет товара (красный, зеленый..)
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    color - название цвета  
  
# product_types - тип товара (ботинки, туфли, платье)
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    color - название типа  
    
# orders - заказы
    id - id заказа  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата удаления записи  
    customer_id - id покупателя  
    order_status_id - статус заказа  


# order_statuses - статусы заказа 
    id - id статуса  
    created_at   - дата создания  
    updated_at - дата обновления  
    deleted_at - дата удаления  
    status_name - название статуса (новый, в обработке, принят, передан в доставку, выполнен, отменен)  

# orders_products - связь таблиц orders и products
    order_id - id заказа  
    product_id - id продукта  
    quantity - количество  

# delivery - информация о доставке
    id - id доставки  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    order_id - id заказа  
    delivery_method - способ доставки (курьер, самовывоз, др.)  
    address - адрес доставки  
    shipping_cost - стоимость доставки  

# delivery_methods - методы доставки
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    delivery_method - название метода  

# payments - информация о платежах (входящих и исходящих) 
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    contragent_name - название плательщика если входящий платеж/получателя если исходящий платеж  
    contragent_inn - ИНН плательщика если входящий платеж/получателя если исходящий платеж  
    contragent_kpp - КПП плательщика если входящий платеж/получателя если исходящий платеж  
    contragent_account - расчетный счет плательщика если входящий платеж/получателя если исходящий платеж  
    contragent_bank_name - название банка плательщика если входящий платеж/получателя если исходящий платеж  
    contragent_bank_bic - БИК банка плательщика если входящий платеж/получателя если исходящий платеж  
    payment_sum - сумма платежа  
    payment_purpose - назначение платежа  
    is_credit - признак платежа (true - входящий, false - исходящий)  
    payment_method - способ платежа   
    customer_id - id плательщика  

# payment_order - связь платежей с заказами
    payment_id - id платежа  
    order_id - id заказа  

# reviews - отзывы о товарах на сайте
    id - id отзыва  
    created_at  - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    product_id - id продукта, по которому оставлен отзыв  
    customer_id - покупатель, оставивший отзыв  
    review_text - текст отзыва  
    vote - оценка от 1 до 5. При добавлении записи в таблицу, триггер рассчитывает среднюю оценку и добавляет ее в таблицу products  

# review_photos - фото товаров, прикрепленных к отзыву 
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    review_id - id отзыва  
    url - ссылка на фото  

# products_in_stock - остатки товаров на складе 
    id - id записи  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    product_id - id товара  
    stock_id - id склада (если возможно несколько складов)  
    purchase_price - закупочная цена товара  
    size - размер  
    quantity - количество (остаток) - с помощью триггера уменьшается после принятия заказа  


# stocks - склады с товарами
    id - id склада   
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    name - название склада  
    address jsonb - адрес склада  


# users - пользователи базы данных (администратор, менеджеры и др) 
    id - id пользователя  
    created_at - дата создания записи  
    updated_at - дата обновления записи  
    deleted_at - дата обновления записи  
    first_name - имя пользователя  
    last_name - фамилия пользователя  
    password_hash - hash пароля  
    email - email  
