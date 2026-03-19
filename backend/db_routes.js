import db from './database.js'

export async function chicken(req, res){
	const result = db.exec('select * from chicken;')
	res.send(result)
}

export async function dynamic_select(req, res){
	let table = req.params.table

	//if (table = 'chicken') table = 'chicken_proper'
	const result = db.exec('select * from '+table+';')
	
	res.send(result)
}


export async function new_egg(req, res){
	let mother = req.params.chicken_id
	if (mother != undefined){
		db.run(`

			insert into egg(color_id, mother_chicken_id, ts_laid) values (
				(abs(random())%(select count(*) from color)),
				`+mother+`,
				datetime()
			)
		`)
	}	
	res.send()
}
export async function hatch_egg(req, res){
	let egg = req.params.egg_id
	db.run(`
		update egg set ts_hatched = datetime() where egg_id = `+egg
	)
	res.send()
}
export async function sell_chicken(req, res){
	let chicken_id = req.params.chicken_id
	db.run('update chicken set state_id = 3 where chicken_id = '+chicken_id)
	res.send()
}
export async function feed_chicken(req, res){
	let chicken_id = req.params.chicken_id
	let food_id = req.params.food_id

	db.run(`update chicken set 
		last_food_id = `+food_id+`,
		ts_last_fed = datetime()
		where chicken_id=`+chicken_id+`;
		`)
	res.send()
}
