-- CREATE STAR SCHEMA

-- 01. DIM MARKETPLACE
drop table if exists warehouse.dim_marketplace cascade;

create table warehouse.dim_marketplace (
    marketplace_id serial primary key,
    marketplace_name text unique
);

insert into warehouse.dim_marketplace (marketplace_name)
select distinct marketplace
from warehouse.stg_order_items;

-- 02 DIM SELLER
drop table if exists warehouse.dim_seller cascade;

create table warehouse.dim_seller (
    seller_id serial primary key,
    seller_name text,
    marketplace_id integer references warehouse.dim_marketplace(marketplace_id),
    unique(seller_name, marketplace_id)
);

insert into warehouse.dim_seller (seller_name, marketplace_id)
select distinct
    s.seller_name,
    m.marketplace_id
from warehouse.stg_order_items s
join warehouse.dim_marketplace m
    on s.marketplace = m.marketplace_name;

-- 03. DIM_DATE
drop table if exists warehouse.dim_date cascade;

create table warehouse.dim_date (
    date_id serial primary key,
    full_date date unique,
    day integer,
    month integer,
    year integer,
    quarter integer
);

insert into warehouse.dim_date (full_date, day, month, year, quarter)
select distinct
    date(order_created_at) as full_date,
    extract(day from order_created_at),
    extract(month from order_created_at),
    extract(year from order_created_at),
    extract(quarter from order_created_at)
from warehouse.stg_order_items
where order_created_at is not null;


-- 04. DIM_PRODUCT
drop table if exists warehouse.dim_product;

create table warehouse.dim_product (
    product_id serial primary key,
    product_name text unique
);

insert into warehouse.dim_product (product_name)
select distinct product_name
from warehouse.stg_order_items
where product_name is not null;

-- 05. DIM_CUSTOMER
drop table if exists warehouse.dim_customer;

create table warehouse.dim_customer (
    customer_id serial primary key,
    customer_username text,
    marketplace text,
    province text,
    city text,
    unique(customer_username, marketplace)
);

-- insert unknown diawal sebagai wadah join fact table untuk customer_username null
insert into warehouse.dim_customer (
    customer_username,
    marketplace,
    province,
    city
)
values (
    'unknown',
    'unknown',
    null,
    null
);

-- insert customer non null
insert into warehouse.dim_customer (
    customer_username,
    marketplace,
    province,
    city
)
select distinct on (customer_username, marketplace)
    customer_username,
    marketplace,
    province,
    city
from warehouse.stg_order_items
where customer_username is not null
order by customer_username, marketplace;

--- validation
select count(*) from warehouse.dim_marketplace;
select count(*) from warehouse.dim_seller;
select count(*) from warehouse.dim_customer;
select count(*) from warehouse.dim_date;
select count(*) from warehouse.dim_product;