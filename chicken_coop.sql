drop database if exists chicken_coop;
create database chicken_coop;
use chicken_coop;

drop table if exists chicken;
create table chicken(
	chicken_id int primary key auto_increment,
    name varchar(50),
    feather_color varchar(6),
    size int,
    from_egg int,
    coop_id int,
    favorite_food_id int,
    affection_meter int,
    sex int,
    alive_state boolean
);
drop table if exists egg;
create table egg(
	egg_id int primary key auto_increment,
    mother int,
    shell_color varchar(6),
    laid_date date,
    hatch_date date,
    foreign key (mother) references chicken(chicken_id) ON DELETE CASCADE
);
drop table if exists coop;
create table coop(
	coop_id int primary key,
    cock_id int,
    wall_material varchar(50),
    foreign key (cock_id) references chicken(chicken_id) ON DELETE CASCADE
);
drop table if exists food;
create table food(
	food_id int primary key,
    name varchar(50)
);
drop table if exists sexandgender;
create table sexandgender(
	sex_id int primary key,
    name varchar(50),
    genderisnotthesameassex blob
);
alter table chicken add foreign key (favorite_food_id) references food(food_id) ON DELETE CASCADE;
alter table chicken add foreign key (from_egg) references egg(egg_id) ON DELETE CASCADE;
alter table chicken add foreign key (sex) references sexandgender(sex_id) ON DELETE CASCADE;

drop view if exists chicks;
create view chicks as 
select * from chicken c inner join egg e on c.from_egg=e.egg_id where e.hatch_date < (
	 SELECT ADDDATE(current_date(), INTERVAL 10 DAY) 
);

drop view if exists parentage;
create view parentage as
select c1.name child, c2.name mother, c3.name father 
	from chicken c1 inner join egg e on c1.from_egg = e.egg_id
    inner join chicken c2 on e.mother = c2.chicken_id
    inner join coop on c2.coop_id = coop.coop_id
    inner join chicken c3 on coop.cock_id = c3.chicken_id;

drop view if exists who_eats_what;
create view who_eats_what as
select c.name Chicken_Name, f.name Food_Name
	from chicken c inner join food f on c.favorite_food_id = f.food_id;

drop view if exists best_foods;
create view best_foods as
select f.name, count(c.chicken_id) count
	from food f left join chicken c on c.favorite_food_id = f.food_id
    group by f.name
    order by count desc;

drop trigger if exists hatching;
create trigger hatching after insert on egg
for each row
insert into chicken(from_egg, size) values (new.egg_id, 1);


insert into food values (1, "wheat seeds");
insert into food values(2, "burger");

insert into sexandgender(sex_id, name) values (1, "Hen");
insert into sexandgender(sex_id, name) values (2, "Cock");
insert into sexandgender(sex_id, name) values (3, "Woke");

insert into coop(coop_id) values (1);

insert into egg(shell_color, laid_date) values("brown", current_date());

insert into chicken(name) values ("Margaret");

select * from chicken;