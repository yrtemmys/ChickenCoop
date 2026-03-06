drop database if exists chicken_coop;
create database chicken_coop;
use chicken_coop;

PRAGMA foreign_keys = OFF


drop table if exists chicken();

drop table if exists egg();

drop table if exists chicken_state();

drop table if exists food();

drop table if exists color();

drop table if exists gender();

drop table if exists chicken_sale();

drop table if exists chicken_base_price();


create table food(
	food_id int primary key autoincrement,
	name varchar(51)
);

create table chicken_state(
	state_id int primary key autoincrement,
	name varchar(51)
);

create table color(
	color_id int primary key autoincrement,
	hex varchar(6),
	name varchar(50)
);

create table gender(
	gender_id int primary key autoincrement,
	name varchar(50)
);

create table chicken(
	chicken_id int primary key autoincrement,
	color_id int foreign key references color(color_id),
	last_food_id int foreign key references food(food_id),
	state_id int foreign key references chicken_state(state_id),
	favorite_food_id int foreign key references chicken_state(state_id),
	origin_egg_id int foreign key references egg(egg_id),
	gender_id int foreign key references gender(gender_id),
	ts_last_fed datetime,
	name varchar(50)
);

create table egg(
	egg_id int primary key autoincrement,
	color_id int,
	mother_chicken_id int foreign key references chicken(chicken_id)
	ts_laid datetime,
	ts_hatched datetime
);

PRAGMA foreign_keys = ON;
