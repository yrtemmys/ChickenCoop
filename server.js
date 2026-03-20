//import connection from './backend/db_connection.js'
//import sql from 'mysql2/promise'
//import { select } from './backend/db_select.js'

import http from'http'
import express from 'express'


import db from './backend/database.js'

import { chicken, test, dynamic_select, new_egg, sell_chicken, hatch_egg, feed_chicken, dynamic_select_sort } from './backend/db_routes.js'

//const result = db.exec("select * from chicken");
//console.log(result[0])


let app = express()

let port = 7821

//const [rows, fields] = await connection.execute("select * from chicken;")
//console.log(rows);


app.use(express.static('./static/'))

app.set('view engine', 'html')
app.set('views', './plublic')



app.get('/',(req, res)=>{
	res.sendFile('./static/index.html')
})

/*
app.get('/chicken', (req, res)=>{
	const [rows, fields] = await connection.execute("select * from chicken;")
	res.send(rows)
})
*/

app.get('/chicken', chicken)
app.get('/test', test)
app.all('/select/:table', dynamic_select)
app.all('/select/:table/:row/:order', dynamic_select_sort)

app.get('/lay/:chicken_id', new_egg)
app.get('/sell/:chicken_id', sell_chicken)
app.get('/hatch/:egg_id', hatch_egg)
app.get('/feed/:chicken_id/:food_id', feed_chicken)


app.listen(port, ()=>{
	console.log('Server is listening on port number: ',port);
})
// await connection.end()
