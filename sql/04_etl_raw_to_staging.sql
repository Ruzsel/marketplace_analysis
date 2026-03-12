-- 1.CREATE TABLE WAREHOUSE
drop table if exists warehouse.stg_order_items;

create table warehouse.stg_order_items (
    order_id text,
    marketplace text,
    seller_name text,
    order_created_at timestamp,
    payment_at timestamp,
    product_name text,
    quantity integer,
    gross_revenue numeric(18,2),
    shipping_fee numeric(18,2),
    refund_amount numeric(18,2),
    customer_username text,
    province text,
    city text,
    order_status text
);

-- 2.INSERT DATA SHOPEE
insert into warehouse.stg_order_items
select
    no_pesanan as order_id,
    'shopee' as marketplace,
    nama_toko as seller_name,
    case
        when trim(waktu_pesanan_dibuat) = '-' then null
        when waktu_pesanan_dibuat like '%/%'
            then to_timestamp(waktu_pesanan_dibuat, 'dd/mm/yyyy hh24:mi')
        else
            timestamp '1899-12-30'
            + (replace(waktu_pesanan_dibuat, ',', '.')::numeric * interval '1 day')
    end as order_created_at,
    case
        when trim(waktu_pembayaran_dilakukan) = '-' then null
        when waktu_pembayaran_dilakukan like '%/%'
            then to_timestamp(waktu_pembayaran_dilakukan, 'dd/mm/yyyy hh24:mi')
        else
            timestamp '1899-12-30'
            + (replace(waktu_pembayaran_dilakukan, ',', '.')::numeric * interval '1 day')
    end as payment_at,
    nama_produk as product_name,
    nullif(trim(jumlah), '-')::integer as quantity,
    nullif(trim(total_pembayaran), '-')::numeric as gross_revenue,
    nullif(trim(ongkos_kirim_dibayar_oleh_pembeli), '-')::numeric as shipping_fee,
    0 as refund_amount,
    username_pembeli as customer_username,
    lower(trim(provinsi)),
    lower(trim(kota_kabupaten)) as city,
    case
        when lower(status_pesanan) like '%success%' then 'completed'
        when lower(status_pesanan) like '%pesanan diterima%' then 'completed'
        when lower(status_pesanan) like '%cancel%' then 'cancelled'
        when lower(status_pesanan) like '%progress%' then 'in_progress'
        else 'other'
    end as order_status
from raw.shopee_orders;

-- check data insert shopee dari raw
select count(*) from warehouse.stg_order_items;

select * from warehouse.stg_order_items limit 10;

select seller_name, sum(gross_revenue)
from warehouse.stg_order_items
group by seller_name;

select
    DATE_TRUNC('month', order_created_at) AS month,
    SUM(gross_revenue)
FROM warehouse.stg_order_items
GROUP BY 1
ORDER BY 1;

select order_created_at, payment_at
from warehouse.stg_order_items
limit 10;

-- 3.INSERT DATA TIKTOK
insert into warehouse.stg_order_items
select
    order_id,
    'tiktok' as marketplace,
    nama_toko as seller_name,
    case
        when trim(created_time) = '-' then null
        when created_time like '%/%'
            then to_timestamp(created_time, 'dd/mm/yyyy hh24:mi')
        else
            timestamp '1899-12-30'
            + (replace(created_time, ',', '.')::numeric * interval '1 day')
    end as order_created_at,
    case
        when trim(paid_time) = '-' then null
        when paid_time like '%/%'
            then to_timestamp(paid_time, 'dd/mm/yyyy hh24:mi')
        else
            timestamp '1899-12-30'
            + (replace(paid_time, ',', '.')::numeric * interval '1 day')
    end as payment_at,
    product_name,
    nullif(trim(quantity), '-')::integer as quantity,
    nullif(
        replace(replace(trim(order_amount), 'IDR ', ''), '.', ''),
        '-'
    )::numeric as gross_revenue,
    nullif(
        replace(replace(trim(shipping_fee_after_discount), 'IDR ', ''), '.', ''),
        '-'
    )::numeric as shipping_fee,
    nullif(
        replace(replace(trim(order_refund_amount), 'IDR ', ''), '.', ''),
        '-'
    )::numeric as refund_amount,
    buyer_username as customer_username,
    lower(trim(province)),
    lower(trim(regency_city)) as city,
    case
        when lower(order_status) like '%cancel%' then 'cancelled'
        when lower(order_status) like '%deliver%' then 'completed'
        when lower(order_status) like '%success%' then 'completed'
        else 'in_progress'
    end as order_status
from raw.tiktok_orders;


-- check data insert tiktok dari raw
select count(*) from warehouse.stg_order_items;

select * from warehouse.stg_order_items
where marketplace ilike '%tiktok%'
limit 10;

select seller_name, sum(gross_revenue)
from warehouse.stg_order_items
where marketplace = 'tiktok'
group by seller_name;

select
    DATE_TRUNC('month', order_created_at) AS month,
    SUM(gross_revenue)
FROM warehouse.stg_order_items
where marketplace ilike '%tiktok%'
GROUP BY 1
ORDER BY 1;

