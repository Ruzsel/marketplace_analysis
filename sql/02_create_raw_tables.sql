-- RAW TABLE SHOPEE
DROP TABLE IF EXISTS raw.shopee_orders;

CREATE TABLE raw.shopee_orders (
    nama_toko TEXT,
    no_pesanan TEXT,
    status_pesanan TEXT,
    alasan_pembatalan TEXT,
    status_pembatalan_pengembalian TEXT,
    no_resi TEXT,
    opsi_pengiriman TEXT,
    antar_ke_counter_pickup TEXT,
    pesanan_harus_dikirimkan_sebelum TEXT,
    waktu_pengiriman_diatur TEXT,
    waktu_pesanan_dibuat TEXT,
    waktu_pembayaran_dilakukan TEXT,
    metode_pembayaran TEXT,
    sku_induk TEXT,
    nama_produk TEXT,
    nomor_referensi_sku TEXT,
    nama_variasi TEXT,
    harga_awal TEXT,
    harga_setelah_diskon TEXT,
    jumlah TEXT,
    returned_quantity TEXT,
    total_harga_produk TEXT,
    total_diskon TEXT,
    diskon_dari_penjual TEXT,
    diskon_dari_shopee TEXT,
    berat_produk TEXT,
    jumlah_produk_dipesan TEXT,
    total_berat TEXT,
    nama_gudang TEXT,
    voucher_ditanggung_penjual TEXT,
    cashback_koin TEXT,
    voucher_ditanggung_shopee TEXT,
    paket_diskon TEXT,
    paket_diskon_dari_shopee TEXT,
    paket_diskon_dari_penjual TEXT,
    potongan_koin_shopee TEXT,
    diskon_kartu_kredit TEXT,
    ongkos_kirim_dibayar_oleh_pembeli TEXT,
    estimasi_potongan_biaya_pengiriman TEXT,
    ongkos_kirim_pengembalian_barang TEXT,
    total_pembayaran TEXT,
    perkiraan_ongkos_kirim TEXT,
    catatan_dari_pembeli TEXT,
    catatan TEXT,
    username_pembeli TEXT,
    nama_penerima TEXT,
    no_telepon TEXT,
    alamat_pengiriman TEXT,
    kota_kabupaten TEXT,
    provinsi TEXT,
    waktu_pesanan_selesai TEXT
);

-- RAW TABLE TIKTOK
DROP TABLE IF EXISTS raw.tiktok_orders;

CREATE TABLE raw.tiktok_orders (
    nama_toko TEXT,
    order_id TEXT,
    order_status TEXT,
    order_substatus TEXT,
    cancelation_return_type TEXT,
    normal_or_preorder TEXT,
    sku_id TEXT,
    seller_sku TEXT,
    product_name TEXT,
    variation TEXT,
    quantity TEXT,
    sku_quantity_of_return TEXT,
    sku_unit_original_price TEXT,
    sku_subtotal_before_discount TEXT,
    sku_platform_discount TEXT,
    sku_seller_discount TEXT,
    sku_subtotal_after_discount TEXT,
    shipping_fee_after_discount TEXT,
    original_shipping_fee TEXT,
    shipping_fee_seller_discount TEXT,
    shipping_fee_platform_discount TEXT,
    payment_platform_discount TEXT,
    buyer_service_fee TEXT,
    handling_fee TEXT,
    shipping_insurance TEXT,
    item_insurance TEXT,
    order_amount TEXT,
    order_refund_amount TEXT,
    created_time TEXT,
    paid_time TEXT,
    rts_time TEXT,
    shipped_time TEXT,
    delivered_time TEXT,
    cancelled_time TEXT,
    cancel_by TEXT,
    cancel_reason TEXT,
    fulfillment_type TEXT,
    warehouse_name TEXT,
    tracking_id TEXT,
    delivery_option TEXT,
    shipping_provider_name TEXT,
    buyer_message TEXT,
    buyer_username TEXT,
    recipient TEXT,
    phone_number TEXT,
    zipcode TEXT,
    country TEXT,
    province TEXT,
    regency_city TEXT,
    districts TEXT,
    villages TEXT,
    detail_address TEXT,
    additional_address_information TEXT,
    payment_method TEXT,
    weight_kg TEXT,
    product_category TEXT,
    package_id TEXT,
    purchase_channel TEXT,
    seller_note TEXT,
    checked_status TEXT,
    checked_marked_by TEXT
);

-- CHECK TABLES
select table_schema, table_name
from information_schema.tables
where table_schema = 'raw';

-- LOAD RAW DATA SHOPEE
COPY raw.shopee_orders
FROM 'D:\\Data Project\\marketplace_analytics\\raw_data\\shopee.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

-- LOAD RAW DATA SHOPEE
COPY raw.tiktok_orders
FROM 'D:\\Data Project\\marketplace_analytics\\raw_data\\tiktok.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'UTF8';

-- VALIDATION IMPORT
SELECT COUNT(*) AS total_shopee_rows FROM raw.shopee_orders;
SELECT COUNT(*) AS total_tiktok_rows FROM raw.tiktok_orders;


