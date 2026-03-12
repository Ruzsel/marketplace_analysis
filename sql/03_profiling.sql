-- 1. profilling shopee
select 
    count(*) as total_rows,
    count(distinct no_pesanan) as distinct_orders
from raw.shopee_orders;

-- 1. profilling tiktok
select
	count(*) as total_rows,
	count(distinct order_id) as distinct_orders
from raw.tiktok_orders;

-- interpretasi
-- total_rows > distinct_orders → grain = order item level, berarti 1 order bisa berisi banyak produk.

-- 2. check null no_pesanan shopee
select count(*) as null_order_id
from raw.shopee_orders
where no_pesanan is null
   or no_pesanan = '';

-- 2. check null order_id tiktok
select count(*) as null_order_id
from raw.tiktok_orders
where order_id is null
   or order_id = '';

-- 3. check format tanggal shopee
select waktu_pesanan_dibuat
from raw.shopee_orders
limit 10;

-- 3. check format tanggal tiktok
select created_time
from raw.tiktok_orders
limit 10;

-- 4. check numeric shopee
select total_pembayaran
from raw.shopee_orders
limit 10;

-- 4. check numeric tiktok
select order_amount
from raw.tiktok_orders
limit 10;


-- 5. check distribusi status shopee
select status_pesanan, count(*)
from raw.shopee_orders
group by status_pesanan
order by count(*) desc;

-- 5. check distribusi status tiktok
select order_status, count(*)
from raw.tiktok_orders
group by order_status
order by count(*) desc;

-- 6. check null username shopee
select count(*) as total_null
from raw.shopee_orders
where username_pembeli is null;

-- 6. check null username tiktok
select count(*) as total_null
from raw.tiktok_orders
where buyer_username is null;