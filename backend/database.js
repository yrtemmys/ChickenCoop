import sqljs from 'sql.js'
import fs from 'fs'

const sql1 = await sqljs();
const db = new sql1.Database();

let data = fs.readFileSync('sql_tables_the_second.sql', 'utf8')
const statements = data.split(';').filter((statement) => statement.trim()!== '');
statements.forEach((statement)=>{
	console.log(statement)
	db.run(statement)
})

db.run("create trigger t_sale update of state_id on chicken begin insert into chicken_sale (chicken_id, selling_price, date) values (new.chicken_id, 20, datetime()); end;")


//db.run("update chicken set state_id = 2 where chicken_id = 1")

export {db as default}
