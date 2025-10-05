set search_path to shop;

-- buyurtma umumiy summasini qaytarish uchun
create or replace function calculate_total_o(p_order_id int)
returns numeric as $$
declare 
    total_sum numeric := 0;
begin 
    select sum(quantity * price)
    into total_sum from order_items where order_id = p_order_id;

    return (total_sum);
end;
$$ language plpgsql;


-- foydalanuvchi uchun chegirma qilib beradi agar vip bo'lsa 20% oddiy bo'lsa 10%
create or replace function apply_discount(p_user_id int, p_product_id int)
returns numeric as $$
declare
    base_price numeric;
    discount_rate numeric := 0;
begin
    select price into base_price
    from product where id = p_product_id;

    -- Agar foydalanuvchi VIP bo‘lsa 20%, oddiy bo‘lsa 10%
    select case
        when is_vip = true then 0.2
        else 0.1
    end into discount_rate
    from users where id = p_user_id;

    return base_price * (1 - discount_rate);
end;
$$ language plpgsql;


--  vip tarifsiz
-- create or replace function apply_discount(p_user_id int, p_product_id int)
-- returns numeric as $$
-- declare
--     base_price numeric;
--     discount numeric := 0.1; -- har doim 10%
-- begin
--     select price into base_price
--     from shop.product
--     where id = p_product_id;

--     return base_price - (base_price * discount);
-- end;
-- $$ language plpgsql;

-- orders – buyurtma haqida umumiy ma’lumot
-- order_items – buyurtmadagi mahsulotlar
-- payments – to‘lov haqida ma’lumot

-- Ammo agar shu yozish jarayonida bitta joyda xato bo‘lsa, masalan payments jadvaliga yozishda muammo chiqsa unda oldingi ikkita jadvalga yozilgan ma’lumotlar ham bekor bo‘ladi
-- Bu holatda ROLLBACK ishlatiladi.

create or replace function create_order(
    p_user_id int,
    p_product_id int,
    p_quantity int,
    p_price numeric
)
returns void as $$
declare
    v_order_id int;
begin
    insert into orders(user_id, order_date, total_amount)
    values (p_user_id, now(), p_quantity * p_price)
    returning id into v_order_id;

    insert into order_items(order_id, product_id, quantity, price)
    values (v_order_id, p_product_id, p_quantity, p_price);

    insert into payments(order_id, amount, status)
    values (v_order_id, p_quantity * p_price, 'pending');

exception
    when others then
        -- xato chiqsa hammasini bekor qiladi
        raise notice 'Xato: %', sqlerrm;
        rollback;
end;
$$ language plpgsql;
