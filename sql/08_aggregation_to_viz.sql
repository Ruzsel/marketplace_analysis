-- 1. sales_monthly.csv
create table sales_monthly as
select
    d.year,
    d.month,
    m.marketplace_name,
    f.order_status,
    count(distinct f.order_id)            as total_orders,
    count(distinct f.customer_id)         as total_customers,
    sum(f.quantity)                       as total_items,
    sum(coalesce(f.gross_revenue, 0))     as total_revenue,
    sum(coalesce(f.gross_revenue, 0))
        / nullif(count(distinct f.order_id), 0) as avg_order_value
from warehouse.fact_order_items f
join warehouse.dim_date d        on f.date_id        = d.date_id
join warehouse.dim_marketplace m on f.marketplace_id = m.marketplace_id
where d.year = 2024
  and d.month between 3 and 12
group by d.year, d.month, m.marketplace_name, f.order_status
order by d.year, d.month;

-- 2. top_product.csv
create table top_product as
select
    d.year,
    d.month,
    m.marketplace_name,
    p.product_name,
    count(distinct f.order_id)        as total_orders,
    sum(f.quantity)                   as total_items_sold,
    sum(coalesce(f.gross_revenue, 0)) as total_revenue
from warehouse.fact_order_items f
join warehouse.dim_date d        on f.date_id        = d.date_id
join warehouse.dim_product p     on f.product_id     = p.product_id
join warehouse.dim_marketplace m on f.marketplace_id = m.marketplace_id
where d.year = 2024
  and d.month between 3 and 12
group by d.year, d.month, m.marketplace_name, p.product_name
order by total_revenue desc;

-- 3. top_seller.csv
create table top_seller as
select
    d.year,
    d.month,
    m.marketplace_name,
    s.seller_name,
    count(distinct f.order_id)        as total_orders,
    sum(coalesce(f.gross_revenue, 0)) as total_revenue,
    sum(coalesce(f.gross_revenue, 0))
        / nullif(count(distinct f.order_id), 0) as avg_order_value
from warehouse.fact_order_items f
join warehouse.dim_date d        on f.date_id        = d.date_id
join warehouse.dim_seller s      on f.seller_id      = s.seller_id
join warehouse.dim_marketplace m on f.marketplace_id = m.marketplace_id
where d.year = 2024
  and d.month between 3 and 12
group by d.year, d.month, m.marketplace_name, s.seller_name
order by total_revenue desc;

-- 4. customer_geography.csv
create table customer_geography as
select
    d.year,
    d.month,
    m.marketplace_name,
    c.province,
    c.city,
    count(distinct f.customer_id)     as total_customers,
    count(distinct f.order_id)        as total_orders,
    sum(coalesce(f.gross_revenue, 0)) as total_revenue
from warehouse.fact_order_items f
join warehouse.dim_date d        on f.date_id        = d.date_id
join warehouse.dim_customer c    on f.customer_id    = c.customer_id
join warehouse.dim_marketplace m on f.marketplace_id = m.marketplace_id
where d.year = 2024
  and d.month between 3 and 12
group by d.year, d.month, m.marketplace_name, c.province, c.city
order by total_revenue desc;

-- export csv for tableau public
copy (
    select *
    from mart.customer_geography
)
to 'd:\data project\marketplace_analytics\export\customer_geography.csv'
delimiter ','
csv header;

copy (
    select *
    from mart.sales_monthly
)
to 'd:\data project\marketplace_analytics\export\sales_monthly.csv'
delimiter ','
csv header;

copy (
    select *
    from mart.top_product
)
to 'd:\data project\marketplace_analytics\export\top_product.csv'
delimiter ','
csv header;

copy (
    select *
    from mart.top_seller
)
to 'd:\data project\marketplace_analytics\export\top_seller.csv'
delimiter ','
csv header;