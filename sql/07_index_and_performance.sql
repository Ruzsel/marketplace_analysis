/*
Ringkasan Index

Fact:

- semua foreign key di-index

- composite (date_id, marketplace_id)

Dimension:

- index di kolom yang sering dipakai join saat ETL.
*/

-- 1. Index di FACT TABLE
-- index untuk semua foreign key.

create index idx_fact_marketplace
on warehouse.fact_order_items (marketplace_id);

create index idx_fact_seller
on warehouse.fact_order_items (seller_id);

create index idx_fact_customer
on warehouse.fact_order_items (customer_id);

create index idx_fact_date
on warehouse.fact_order_items (date_id);

create index idx_fact_product
on warehouse.fact_order_items (product_id);

-- 2. Composite Index
/* Untuk query analitik seperti:
where date_id between X and Y
group by marketplace_id
*/
create index idx_fact_date_marketplace
on warehouse.fact_order_items (date_id, marketplace_id);

-- 3. Index di Dimension
-- tambah index di kolom yang sering dipakai join saat ETL.

create index idx_dim_marketplace_name
on warehouse.dim_marketplace (marketplace_name);

create index idx_dim_product_name
on warehouse.dim_product (product_name);

create index idx_dim_seller_name_marketplace
on warehouse.dim_seller (seller_name, marketplace_id);

create index idx_dim_customer_lookup
on warehouse.dim_customer (customer_username, marketplace);

-- 4. Analyze table
analyze warehouse.fact_order_items;
analyze warehouse.dim_customer;
analyze warehouse.dim_seller;
analyze warehouse.dim_product;
analyze warehouse.dim_marketplace;
analyze warehouse.dim_date;

-- 5. Test Performance
explain analyze
select
    m.marketplace_name,
    sum(f.gross_revenue) as total_revenue
from warehouse.fact_order_items f
join warehouse.dim_marketplace m
    on f.marketplace_id = m.marketplace_id
group by m.marketplace_name;