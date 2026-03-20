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

drop table if exists letters;

drop table if exists syllable_patterns;

create table letters (
	letter varchar(2),
	type integer
);
insert into letters values ('a', 1),('e', 1),('i',1),('o',1),('u',1),('y',1);
insert into letters values ('t',2),('d',2),('g',2),('ch',2),('b',2),('p',2),('k',2),('h',2);
insert into letters values ('w',3),('r',3),('s',3),('f',3),('z',3),('v',3),('sh',3),('l',3),('n',3),('m',3);

create table syllable_patterns (
	char1 integer,
	char2 integer,
	char3 integer
);
-- as example, a is vowel, k is explative, m is soft
-- am-, amk, ak-, ka-, kam, kma, ma-, mak
insert into syllable_patterns values
(1,2,0),(1,3,2),(1,3,0),
(2,1,0),(2,1,3),
(3,1,0),(3,1,2);



create view syllables as 
	select (l1.letter || l2.letter ||  l3.letter) as syl
	from syllable_patterns s join letters l1 on l1.type = char1
	join letters l2 on l2.type = char2
	join letters l3 on (l3.type = char3) or (l3.type = 0)
;


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

insert into gender (name, price_factor) values ('Rooster', 70);
insert into gender (name, price_factor) values ('Hen', 100);
insert into gender (name, price_factor) values ('Enby', 110);

insert into chicken_base_price (value, since_date) values (2000, '2026-03-13 00:00:00');

insert into chicken(color_id, favorite_food_id, state_id, origin_egg_id, gender_id, name) values

	(
		3,
		(abs(random())%(select count(*) from food))+1, 
		1, 
		1, 
		2,
		'Margaret'
	)
	;

PRAGMA foreign_keys = ON;

insert into egg (color_id, mother_chicken_id, ts_laid) values (0, 1, '2026-03-13 00:00:00');

--create trigger t_sale update of state_id on chicken
--	begin
--		insert into chicken_sale (chicken_id, selling_price, date) values (new.chicken_id, 20, datetime());
--	end;


create view chicken_proper as
	select ch.chicken_id, ch.name as name, co.name as color, f.name as fav_food, f1.name last_food, ch.ts_last_fed, cs.name as state, eg.name as mother, ge.name as gender 
	from chicken       as ch
	left join color         as co on ch.color_id         = co.color_id
	left join food          as f  on ch.favorite_food_id = f.food_id
	left join food          as f1 on ch.last_food_id     = f1.food_id
	left join chicken_state as cs on ch.state_id         = cs.state_id
	left join egg           as e  on ch.origin_egg_id    = e.egg_id
	left join gender        as ge on ch.gender_id        = ge.gender_id
	left join chicken       as eg on e.mother_chicken_id = eg.chicken_id
	;

create view egg_proper as
	select eg.egg_id, co.name, ch.name, eg.ts_laid 
	from egg eg
	left join color co on eg.color_id = co.color_id
	left join chicken ch on eg.mother_chicken_id = ch.chicken_id
	where eg.ts_hatched is null
	;

create view chicken_ranking as
	select ch.chicken_id, ch.name, count(eg.egg_id) as eggs_laid 
	from chicken as ch
	join egg as eg on eg.mother_chicken_id = ch.chicken_id
	group by chicken_id
	having eggs_laid > 0
	order by eggs_laid desc;

create view chicken_prices as
	select ch.chicken_id, ch.name, cp.color, co.price_factor, cp.gender, ge.price_factor, cp.state, cs.price_factor, 
		( co.price_factor * ge.price_factor * cs.price_factor * ((cr.eggs_laid/5)+1) * (
			select value from chicken_base_price as cbp where cbp.since_date < datetime() 
		) / (100 * 100 * 100)) as price_total
	from chicken as ch
	join chicken_proper as cp on ch.chicken_id=cp.chicken_id
	left join chicken_ranking as cr on ch.chicken_id = cr.chicken_id
        left join color as co on ch.color_id = co.color_id	
	left join gender as ge on ch.gender_id = ge.gender_id
	left join chicken_state as cs on ch.state_id = cs.state_id
	;



PRAGMA foreign_keys = OFF;



with 
colors as (select count(*) as c from color),
foods as (select count(*) from food),
genders as (select count(*) from gender)
insert into chicken(color_id, favorite_food_id, state_id, origin_egg_id, gender_id, name) values

	(
		(abs(random())%(select * from colors))+1,
		(abs(random())%(select * from foods))+1, 
		1, 
		1, 
		(abs(random())%(select * from genders))+1, 
		(select upper(substr(name,1,1))||substr(name,2) from (
			select group_concat(syl,'') as name from (
				select syl from syllables order by random() limit (abs(random())%3)+1
			)
		))
	)
	;

--PRAGMA foreign_keys = ON;


--select upper(substr(name,1,1))||substr(name,2) from (
--	select group_concat(syl,'') as name from (
--		select syl from syllables order by random() limit (abs(random())%3)+1
--	)
--);




create trigger t_sale after update of state_id on chicken 
	begin 
	insert into chicken_sale (chicken_id, selling_price, date) values (new.chicken_id, 20, datetime()); 
	end;

create trigger hatching after update on egg
	begin
	insert into chicken(color_id, favorite_food_id, state_id, origin_egg_id, gender_id, name) values

		(
			(abs(random())%(select count(*) from color))+1,
			(abs(random())%(select count(*) from food))+1, 
			1, 
			new.egg_id, 
			(abs(random())%(select count(*) from gender))+1, 
			(select upper(substr(name,1,1))||substr(name,2) from (
				select group_concat(syl,'') as name from (
					select syl from syllables order by random() limit (abs(random())%3)+1
				)
			))
		)
		;
end;

pragma foreign_key = off;
update egg set ts_hatched = datetime() where egg_id = 1;
--pragma foreign_key = on;

-- cock fight trigger. lets leave that commented out..

--create trigger cock_fiht after insert on chicken
--	when (select count(*) from chicken where gender_id=1 and state_id=1)>3
--	begin
--		update chicken set state_id=2 where chicken_id = (
--			select chicken_id from chicken where gender_id=1 and state_id = 1 order by random() limit 1
--		);
--	end;

