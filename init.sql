create database shop_db;

use shop_db;

create table if not exists shop_db.customers (
  id int AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp default now(),
  updated_at timestamp,
  deleted_at timestamp,
  first_name varchar(255),
  last_name varchar(255),
  phone varchar(100) not null,
  email varchar(100) not null unique,
  password_hash varchar(255) not null,
  address_id int
);

create table if not exists shop_db.address(
  id int AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  address_jsonb json,
  postal_code int, 
  country varchar(100),
  region varchar(100),
  locality varchar(100),
  address_end text
);
	
create table if not exists shop_db.products (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  name varchar(255) NOT NULL,
  description text,
  price numeric,
  gender smallint,
  product_category_id int references shop_db.product_categories(id),
  product_type_id int references shop_db.product_types(id),
  priduct_brand_id int references shop_db.product_brands(id),
  product_season_id int references shop_db.product_seasons(id),
  product_color_id int references shop_db.product_colors(id),
  avg_raiting float,
  available_sizes json
 );

create table if not exists shop_db.products_photos (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  product_id int references shop_db.products(id),
  url varchar(100)
 );
 
create table if not exists shop_db.product_categories (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  category_name varchar(255),
  photo varchar(100)
 );

create table if not exists shop_db.product_seasons (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  season_name varchar(100)
);

create table if not exists shop_db.product_brands (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  brand_name varchar(100)
 );
 
create table if not exists shop_db.product_types (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  type_name varchar(100),
  category_id int references shop_db.categories(id)
 );
 
create table if not exists shop_db.product_colors (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  color_name varchar(100)
 );
 
create table if not exists shop_db.orders (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  customer_id int references shop_db.customers(id),
  order_status_id int references shop_db.order_statuses(id)
);

create table if not exists shop_db.order_statuses (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  status_name varchar(50)
);

create table if not exists shop_db.orders_products (
  order_id int references shop_db.orders(id),
  product_id int references shop_db.products(id),
  quantity int NOT NULL DEFAULT 1
);

create table if not exists shop_db.delivery (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  order_id int references shop_db.orders(id),
  delivery_status int references shop_db.delivery_statuses(id),
  delivery_method int references shop_db.delivery_methods(id),
  address_id int references shop_db.address(id), 
  shipping_cost numeric
);

create table if not exists shop_db.delivery_methods (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  delivery_method varchar(255)
);

create table if not exists shop_db.delivery_statuses (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  status_name varchar(100)
);

create table if not exists shop_db.payments (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  contragent_name text,
  contragent_inn text,
  contragent_kpp text ,
  contragent_account text ,
  contragent_bank_name text ,
  contragent_bank_bic text ,
  payment_sum numeric NOT NULL,
  payment_purpose numeric,
  is_credit boolean NOT NULL,
  payment_method varchar(100),
  customer_id int references shop_db.customers(id)
);

create table if not exists shop_db.payment_order (
  payment_id int references shop_db.payments(id), 
  order_id int references shop_db.orders(id)
);

create table if not exists shop_db.reviews (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  product_id int references shop_db.products(id), 
  customer_id int references shop_db.customers(id), 
  review_text text,
  vote smallint
);

create table if not exists shop_db.review_photos (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  review_id int references shop_db.reviews(id),
  url varchar(255)
);

create table if not exists shop_db.products_in_stock (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  product_id int references shop_db.products(id),
  stock_id int references shop_db.stocks(id),
  purchase_price numeric, 
  size smallint,
  quantity int
);

create table if not exists shop_db.stocks (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  name varchar(100),
  address int references shop_db.address(id)
);

create table if not exists shop_db.users (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created_at timestamp DEFAULT NOW(),
  updated_at timestamp,
  deleted_at timestamp,
  first_name varchar(255),
  last_name varchar(255),
  password_hash varchar(255) NOT NULL,
  email varchar(100) NOT NULL UNIQUE
);