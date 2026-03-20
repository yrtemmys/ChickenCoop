import sqljs from 'sql.js'
import fs from 'fs'

const sql1 = await sqljs();
const db = new sql1.Database();

let data = fs.readFileSync('sql_tables_the_second.sql', 'utf8')
const statements = data.split(';').filter((statement) => statement.trim()!== '');
statements.forEach((statement)=>{
	console.log(statement)
	console.log("----------")
	db.run(statement)
})

db.run(`
	create trigger t_sale after update of state_id on chicken 
	begin 
	insert into chicken_sale (chicken_id, selling_price, date) values (new.chicken_id, 20, datetime()); 
	end;
`)

db.run(`
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
`)


db.run(`
	pragma foreign_key = off;
	update egg set ts_hatched = datetime() where egg_id = 1;
	--pragma foreign_key = on;
`)

// cock fight trigger. lets leave that commented out..

db.run(`
	create trigger cock_fight after insert on chicken
	when (select count(*) from chicken where gender_id=1 and state_id=1)>3
	begin
		update chicken set state_id=3 where chicken_id = (
			select chicken_id from chicken where gender_id=1 and state_id = 1 order by random() limit 1
		);
	end;
`)


// 0000-00-00 00:00:00



/*
db.exec("with syls as ("+"select (l1.letter || l2.letter ||  l3.letter) "+
	"from syllables s join letters l1 on l1.type = char1 "+
	"join letters l2 on l2.type = char2 "+
	"join letters l3 on (l3.type = char3) or (l3.type = 0) "+
	" order by random()"
	).forEach(e=>{
	console.log(e)
})
*/






//db.run("update chicken set state_id = 2 where chicken_id = 1")

export {db as default}
