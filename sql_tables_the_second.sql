--drop database if exists chicken_coop;
--create database chicken_coop;
--use chicken_coop;

PRAGMA foreign_keys = OFF;


drop table if exists chicken;

drop table if exists egg;

drop table if exists chicken_state;

drop table if exists food;

drop table if exists color;

drop table if exists gender;

drop table if exists chicken_sale;

drop table if exists chicken_base_price;


create table food(
	food_id integer primary key autoincrement,
	name varchar(51)
);

create table chicken_state(
	state_id integer primary key autoincrement,
	name varchar(51),
	price_factor integer
);

create table color(
	color_id integer primary key autoincrement,
	hex varchar(6),
	name varchar(50),
	price_factor integer
);

create table gender(
	gender_id integer primary key autoincrement,
	name varchar(50),
	price_factor integer
);

create table chicken(
	chicken_id integer primary key autoincrement,
	color_id integer references color(color_id),
	last_food_id integer references food(food_id),
	state_id integer references chicken_state(state_id),
	favorite_food_id integer references chicken_state(state_id),
	origin_egg_id integer references egg(egg_id),
	gender_id integer references gender(gender_id),
	ts_last_fed varchar(19),
	name varchar(50)
);

create table egg(
	egg_id integer primary key autoincrement,
	color_id integer,
	mother_chicken_id integer references chicken(chicken_id),
	ts_laid varchar(19),
	ts_hatched varchar(19)
);

create table chicken_sale(
	sale_id integer primary key autoincrement,
	chicken_id integer references chicken(chicken_id),
	selling_price integer,
	date varchar(19) 
);

create table chicken_base_price(
	price_id integer primary key autoincrement,
	value integer,
	since_date varchar(19)
);

insert into chicken (name) values ('Margaret');

PRAGMA foreign_keys = ON;

insert into food (name) values ('Wheat Seeds');
insert into food (name) values ('Acorns');
insert into food (name) values ('Potato Salad');
insert into food (name) values ('Big Mac');
insert into food (name) values ('Corn');
insert into food (name) values ('Fish Paste');
insert into food (name) values ('Peas');
insert into food (name) values ('Oats');
insert into food (name) values ('Base Feed');
insert into food (name) values ('Kelp');
insert into food (name) values ('Aragonite');
insert into food (name) values ('Sunflower Seeds');
insert into food (name) values ('Rice');
insert into food (name) values ('Pumpkin Seeds');
insert into food (name) values ('Sesame Seeds');
insert into food (name) values ('Popcorn');
insert into food (name) values ('Spinach');
insert into food (name) values ('Broccoli');


insert into chicken_state (name, price_factor) values ('Alive', 100);
insert into chicken_state (name, price_factor) values ('Dead', 50);
insert into chicken_state (name, price_factor) values ('Sold', 0);

insert into color (hex, name, price_factor) values ('FFFFFF', 'White', 100);
insert into color (hex, name, price_factor) values ('993333', 'Brown', 70);
insert into color (hex, name, price_factor) values ('0000FF', 'Blue', 130);

insert into gender (name, price_factor) values ('Man', 70);
insert into gender (name, price_factor) values ('Woman', 100);
insert into gender (name, price_factor) values ('Non Binary', 110);

insert into chicken_base_price (value, since_date) values (2000, '2026-03-13 00:00:00');

insert into egg (color_id, mother_chicken_id, ts_laid) values (0, 1, '2026-03-13 00:00:00');

--create trigger t_sale update of state_id on chicken
--	begin
--		insert into chicken_sale (chicken_id, selling_price, date) values (new.chicken_id, 20, datetime());
--	end;


create view chicken_proper as
	select ch.name as name, co.name as color, f.name as fav_food, f1.name last_food, ch.ts_last_fed, cs.name as state, eg.name as mother, ge.name as gender 
	from chicken       as ch
	left join color         as co on ch.color_id         = co.color_id
	left join food          as f  on ch.favorite_food_id = f.food_id
	left join food          as f1 on ch.last_food_id     = f1.food_id
	left join chicken_state as cs on ch.state_id         = cs.state_id
	left join egg           as e  on ch.origin_egg_id    = e.egg_id
	left join chicken       as eg on e.mother_chicken_id = eg.chicken_id
	left join gender        as ge on ch.gender_id        = ge.name
	;
