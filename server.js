import connection from './backend/db_connection.js'
import sql from 'mysql2/promise'
import http from'http'
import express from 'express'
import { select } from './backend/db_select.js'

let app = express()

let port = 8080

const [rows, fields] = await connection.execute("select * from chicken;")
console.log(rows);


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

app.get('/chicken', select)

app.listen(port, ()=>{
	console.log('Server is listening on port number: $(port)',port);
})
// await connection.end()
