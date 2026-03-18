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
	console.log('now on route /lay/'+mother)
	if (mother != undefined){
		db.run(`

			insert into egg(color_id, mother_chicken_id, ts_laid) values (
				(abs(random())%(select count(*) from color)),
				`+mother+`,
				datetime()
			)
		`)
	}else{
		// if running without a given chicken_id, it can currently pick sold, dead, or male chickens as mothers too.
		db.run(`
			insert into egg(color_id, mother_chicken_id, ts_laid) values (
				(abs(random())%(select count(*) from color)),
				(abs(random())%(select count(*) from chicken)),
				datetime()
			)
		`)
	}
}
export async function hatch_egg(req, res){
	let egg = req.params.egg_id
	console.log(egg)
	db.run(`
		update egg set ts_hatched = datetime() where egg_id = `+egg
	)
}
export async function sell_chicken(req, res){
	let chicken_id = req.params.chicken_id
	console.log(chicken_id)
	db.run('update chicken set state_id = 3 where chicken_id = '+chicken_id)
}
