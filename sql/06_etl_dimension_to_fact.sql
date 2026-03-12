--- DESAIN FACT TABLE ---
-- 1 ROW = 1 ORDER_ID + 1 PRODUCT NAME

--- TABLE FACT_ORDER
drop table if exists warehouse.fact_order_items cascade;

create table warehouse.fact_order_items (
    fact_id bigserial primary key,
    order_id text,
    marketplace_id integer references warehouse.dim_marketplace(marketplace_id),
    seller_id integer references warehouse.dim_seller(seller_id),
    customer_id integer references warehouse.dim_customer(customer_id),
    date_id integer references warehouse.dim_date(date_id),
    product_id integer references warehouse.dim_product(product_id),
    quantity integer,
    gross_revenue numeric(18,2),
    shipping_fee numeric(18,2),
    refund_amount numeric(18,2),
    order_status text
);

insert into warehouse.fact_order_items (
    order_id,
    marketplace_id,
    seller_id,
    customer_id,
    date_id,
    product_id,
    quantity,
    gross_revenue,
    shipping_fee,
    refund_amount,
    order_status
)
select
    s.order_id,
    m.marketplace_id,
    se.seller_id,
    coalesce(
        c.customer_id,
        (select customer_id
         from warehouse.dim_customer
         where customer_username = 'unknown'
         limit 1)
    ),
    d.date_id,
    p.product_id,
    s.quantity,
    s.gross_revenue,
    s.shipping_fee,
    s.refund_amount,
    s.order_status
from warehouse.stg_order_items s
join warehouse.dim_marketplace m
    on s.marketplace = m.marketplace_name
join warehouse.dim_seller se
    on trim(s.seller_name) = trim(se.seller_name)
    and m.marketplace_id = se.marketplace_id
left join warehouse.dim_customer c
    on trim(s.customer_username) = trim(c.customer_username)
    and s.marketplace = c.marketplace
join warehouse.dim_date d
    on date(s.order_created_at) = d.full_date
join warehouse.dim_product p
    on s.product_name = p.product_name;

--- VALIDASI
select count(*) from warehouse.stg_order_items;
select count(*) from warehouse.fact_order_items;
