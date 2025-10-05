set search_path to shop;


-- trigger funksiyasi: yangi order qo‘shilganda avtomatik payment yozish
create or replace function create_payment()
returns trigger as $$
declare
    total_amount numeric(12,2);
begin
    select sum(oi.price * oi.quantity)
    into total_amount
    from shop.order_items as oi
    where oi.order_id = new.id;

    if total_amount is not null then
        insert into shop.payments(order_id, amount, status_id)
        values (new.id, total_amount, 1); -- 1 = pending
    end if;

    return new;
end;
$$ language plpgsql;

create trigger trg_create_payment_after_order
after insert on shop.orders
for each row
execute function create_paymen();


-- o'zgartirilgan maxsulotni narxini aloqida log ga yozib boradi
create or replace function shop.log_price_H()
returns trigger as $$
begin 
    if new.price <> old.price then 
        insert into shop.product_price_history(product_id, old_price, new_price)
        values (old.id, old.price, new.price);
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_log_price_change
after update on shop.product
for each row
execute function shop.log_price_H();

