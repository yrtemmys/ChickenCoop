import connection from './db_connection.js'
import sql from 'mysql2'

export async function select(req, res){
	const [rows, fields] = await connection.execute("select * from chicken;")
	let result = {}
	rows.forEach((e, i, a)=>{
		result[i]=e
	})
	res.send(result)
}
