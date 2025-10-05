set search_path to shop;

alter table shop.users add constraint password_check check(length(password) >= 8);

alter database shopdb set search_path = shop, public;
select * from shop.users;
select * from shop.category;
select * from shop.product;
select * from shop.status;
select * from shop.orders;
select * from shop.order_items;
select * from shop.payments;

-- 1: Har bir user nechta order qilgan
select u.id, u.full_name, 
       count(o.id) as total_orders
from shop.users as u
inner join orders as o on u.id = o.user_id
group by u.id, u.full_name 
order by u.id asc, u.full_name asc;

-- 2: User qaysi productlardan qancha olgan va summasi
select u.full_name, p.name as product_name, oi.quantity, oi.price, 
       (oi.quantity * oi.price) as total_price
from shop.users as u
inner join orders as o on u.id = o.user_id
inner join order_items as oi on o.id = oi.order_id
inner join product as p on p.id = oi.product_id
order by u.id, p.name;

-- 3: Har bir product nechta buyurtma qilingan
select p.id, p.name as product_name,
       count(oi.id) as order_count
from shop.order_items as oi
inner join product as p on oi.product_id = p.id
group by p.id, p.name
order by order_count desc;

-- 4: User buyurtmasi product, category va status bilan
select u.id as user_id,
       u.full_name,
       p.name as product_name,
       oi.price,
       oi.quantity,
       (oi.price * oi.quantity) as total_price,
       c.name as category_name,
       c.description as category_description,
       o.order_date,
       py.status_id,
       s.status_name
from users as u
inner join orders as o on o.user_id = u.id
inner join order_items as oi on oi.order_id = o.id 
inner join product as p on p.id = oi.product_id
inner join category as c on c.id = p.category_id
left join payments as py on py.order_id = o.id
left join status as s on py.status_id = s.id;

-- 5: Eng ko‘p buyurtma qilgan 5 ta user
select u.id as user_id, u.full_name,
       count(o.id) as total_orders 
from shop.users as u
inner join shop.orders as o on o.user_id = u.id
group by u.id, u.full_name
order by total_orders desc
limit 5;

-- 6: Xarid summasi 900 dan katta bo‘lgan userlar
select u.id, u.full_name, 
       sum(p.price * oi.quantity) as total_amount
from shop.users u
inner join shop.orders o on o.user_id = u.id
inner join shop.order_items oi on oi.order_id = o.id
inner join shop.product p on p.id = oi.product_id
group by u.id, u.full_name
having sum(p.price * oi.quantity) > 900;

-- 7: Userlar buyurtma soni, quantity, umumiy summa va rank
select u.id as user_id, 
       u.full_name,
       count(distinct o.id) as total_orders,
       sum(oi.quantity) as total_quantity,
       sum(oi.price * oi.quantity) as total_sum,
       rank() over (order by sum(oi.price * oi.quantity) desc) as price_rank
from shop.users as u
inner join shop.orders as o on o.user_id = u.id
left join shop.order_items as oi on oi.order_id = o.id
group by u.id, u.full_name;

-- 8: Userlar bo‘yicha har bir product qancha olingan va summasi
select u.id, u.full_name, p.name as product_name,
       sum(oi.quantity) as total_quantity,
       sum(oi.price * oi.quantity) as total_sum,
       rank() over (order by sum(oi.price * oi.quantity) desc) as price_rank
from shop.users as u
inner join shop.orders as o on o.user_id = u.id
inner join shop.order_items as oi on oi.order_id = o.id
inner join shop.product as p on p.id = oi.product_id
group by u.id, u.full_name, p.name
order by u.id, p.name;

-- 10: martadan ortiq sotilgan mahsulotlarni chiqarish
select 
    p.id as product_id,
    p.name as product_name,
    sum(oi.quantity) as total_sold,
    c.name as category_name
from shop.product as p
inner join shop.order_items as oi on p.id = oi.product_id
inner join shop.category as c on p.category_id = c.id
group by p.id, p.name, c.name
having sum(oi.quantity) > 10
order by total_sold desc;

-- 11: Chegirmadan oldin va keyin tushgan daromadni solishtirish
select 
    p.id as product_id,
    p.name as product_name,
    sum(p.price * oi.quantity) as total_before_discount,
    sum((p.price - (p.price * p.discount / 100)) * oi.quantity) as total_after_discount,
    (sum(p.price * oi.quantity) - sum((p.price - (p.price * p.discount / 100)) * oi.quantity)) as discount_difference
from shop.product as p
inner join shop.order_items as oi on p.id = oi.product_id
group by p.id, p.name
order by discount_difference desc;
