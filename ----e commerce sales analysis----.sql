----e commerce sales analysis----

----1. Menghitung bulan dengan total nilai transaksi paling besar------------ 

SELECT
	EXTRACT(month from order_date) AS bulan,
sum(after_discount) AS total_transaksi_terbesar
from order_detail
WHERE
	EXTRACT(year from order_date)=2021
    and is_valid =1
group BY
	bulan
order BY
	total_transaksi_terbesar DESC limit 4;
    
    
-----2. Kategori dengan nilai transaksi paling besar-------- 

SELECT
	sku_detail.category,
    SUM(order_detail.after_discount) AS total_transaksi_terbesar
from
	order_detail
JOIN
	sku_detail on order_detail.sku_id=sku_detail.id
WHERE
	EXTRACT(year from order_detail.order_date) = 2022
    and 
    order_detail.is_valid =1
group BY
	sku_detail.category
order by 
	total_transaksi_terbesar DESC limit 1
    
----3. Membandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022---- 
---dan mana saja transaksi yang mengalami penurunan dan peningkatan------- 

SELECT 
	category,
    MAX(CASE WHEN tahun =2021 THEN total_transaksi END) as total_2021,
    MAX(case when tahun = 2022 THEN total_transaksi end) as total_2022,
case 
	when max(case WHEN tahun =2022 then total_transaksi end)> 
    max(case WHEN tahun = 2021 then total_transaksi end) then 'peningkatan'
    when max(case when tahun = 2022 then total_transaksi end)<
    max(case when tahun = 2021 then total_transaksi end) then 'penurunan'
    else 'tidak berubah' end as status_perubahan
 from(
 	SELECT
 		sd.category,
 	EXTRACT(year from od.order_date) as tahun,
 	ROUND(sum(od.after_discount * od.qty_ordered)::NUMERIC, 0) as total_transaksi
   FROM order_detail od 
   JOIN
   sku_detail sd on od.sku_id=sd.id
   WHERE
   od.is_valid=1
   and EXTRACT(year from od.order_date)in (2021,2022)
   group BY sd.category,EXTRACT(year from od.order_date)) as transaki_per_kategori
   group BY
   category
   order BY
   status_perubahan asc;
   
   
   -------4. menampilkan top 5 metode pembayaran yang paling populer di tahun 2022-------- 
   SELECT 
   payment_method,
   COUNT(DISTINCT id)AS total_payment
   FROM(
     SELECT
     od.id,
     pd.payment_method
     FROM
     order_detail od
     JOIN
     payment_detail pd on od.payment_id=pd.id
     WHERE 
     od.is_valid=1
     	and EXTRACT(YEAR FROM od.order_date)=2022)AS order_payment
     group by 
     payment_method
     order BY
     total_payment desc limit 5;
   
   -------5. Memfilter top 5 produk dengan transaksi terbanyak--------
   
  SELECT
  product_category,
  total_sales
  from (
    SELECT
    	CASE
    	when LOWER(sd.sku_name) like '%samsung%' then 'Samsung'
    	when LOWER(sd.sku_name) like '%apple%' then 'Apple'
        when LOWER(sd.sku_name) like '%sony%' then 'Sony'
       	when LOWER(sd.sku_name) like '%huawei%' then 'Huawei'
       	when LOWER(sd.sku_name) like '%lenovo%' then 'Lenovo'
    	when LOWER(sd.sku_name) like '%macbook%' then 'Macbook'
   		else sd.sku_name
    	END as product_category,
    	round(sum(od.after_discount * od.qty_ordered)::numeric,0)as total_sales
    	FROM
    		order_detail od
    	JOIN
    		sku_detail sd on od.sku_id=sd.id
    	WHERE
    		od.is_valid=1
    	and sd.sku_name ilike Any (array ['%Samsung%','%Apple%','%Sony%','%Huawei%','%Lenovo%','%Macbook%'])
    	group by 
    		product_category) as Product_Sales
        order BY
        	total_sales DESC;
            
   select * from sku_detail where category; 
   
