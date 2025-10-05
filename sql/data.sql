set search_path to shop;

insert into shop.users(full_name, email, password)
values ('Qudratbekh', 'anonshack48@gmail.com', crypt('anons0202', gen_salt('bf'))),
       ('Muhammad', 'muhammad@gmail.com', crypt('muhammad0505', gen_salt('bf')));

insert into shop.category(name, description)
values ('Phone', 'the best phone'),
       ('Toys', 'the best toys');

insert into shop.product(name, description, price, discount, category_id)
values ('Iphone 15 pro max', 'good', 1200.00, 1, 1),
       ('Samsung S25 ultra pro max binafsha rang', 'good', 1000.00, 1, 1),
       ('Malibu 2 turbo', 'good', 100.00, 1, 2);
      
insert into shop.status(id, status_name)
values (1, 'pending'),
       (2, 'paid'),
       (3, 'failed'),
       (4, 'shipped'),
       (5, 'cancelled');

insert into shop.orders(user_id, order_date, status_id)
values (1, '2025-10-03', 2),
       (1, '2024-01-01', 2),
       (2, '2025-09-30', 2);

insert into shop.order_items(order_id, product_id, quantity, price)
values (1, 1, 2, 1200.00),
       (1, 2, 1, 1100.00),
       (3, 2, 1, 1000.00);

insert into shop.payments(order_id, amount, status_id)
values (1, 1200.00, 2),
       (2, 1000.00, 2);

select calculate_total_o(5)

ALTER TABLE shop.users
ADD COLUMN is_vip boolean DEFAULT false;


UPDATE shop.users SET is_vip = true WHERE id = 1;
