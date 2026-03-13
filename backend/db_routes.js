import db from './database.js'

export async function chicken(req, res){
	const result = db.exec('select * from chicken;')
	res.send(result)
}

export async function dynamic_select(req, res){
	let table = req.params.table

	if (table = 'chicken') table = 'chicken_proper'
	const result = db.exec('select * from '+table+';')
	
	res.send(result)
}
