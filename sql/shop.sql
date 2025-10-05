create schema shop;
set search_path to shop;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

create table users(
      id bigserial primary key,
      full_name varchar(60) not null,
      email varchar(50) not null unique,
      password varchar(100) not null,
      is_vip boolean default false,
      created_at timestamp with time zone default now() not null
);

create table category(
      id bigserial primary key,
      name varchar(60) not null unique,
      description text
);

create table product(
      id bigserial primary key,
      name varchar(60) not null,
      description text not null,
      price numeric(10, 2) not null,
      discount numeric(10, 2) default 0,
      category_id bigint references category(id) on delete set null,
      created_at timestamp with time zone default now() not null
);

create table status(
      id bigserial primary key,
      status_name varchar(50) not null unique
);

create table orders(
      id bigserial primary key,
      user_id bigint references users(id) on delete cascade,
      order_date date not null default current_date,
      status_id bigint references status(id)
);

create table order_items(
      id bigserial primary key,
      order_id bigint references orders(id) on delete cascade,
      product_id bigint references product(id),
      quantity int not null,
      price numeric(10, 2) not null
);

create table payments(
      id bigserial primary key,
      order_id bigint references orders(id) on delete cascade,
      amount numeric(10, 2) not null,
      status_id bigint references status(id),
      paid_at timestamp with time zone default now() not null
);

create table if not EXISTS shop.product_price_history(
      id bigserial primary key,
      product_id int references shop.product(id) on delete cascade,
      old_price numeric(10, 2) not null,
      new_price numeric(10, 2) not null,
      change_at timestamp default current_timestamp
);
