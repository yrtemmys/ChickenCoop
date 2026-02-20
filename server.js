let sql = require('mysql2')
let http = require('http')
let express = require('express')

let app = express()

let port = 8080

let con = sql.createConnection({
	host: "localhost",
	user: "code",
	password: "pw",
	database: "chicken_coop"
});

con.connect(function(err){
	if(err) throw err;
	console.log("conneciton yay");

	con.query("select * from chicken;",(err, results,fields)=>{
		if(err) throw err;
		console.log(results);
	})

//	con.end();
});

app.use(express.static('./static/'))

app.set('view engine', 'html')
app.set('views', './plublic')



app.get('/',(req, res)=>{
	res.sendFile('./static/index.html')
})

app.get('/chicken', (req, res)=>{
con.connect(function(err){
	if(err) throw err;
	console.log("conneciton yay");

	con.query("select * from chicken;",(err, results,fields)=>{
		if(err) throw err;
		res.send(results);
	})

	con.end();
});
/*

	let c_name = "margaret";
	res.send({
		"name":c_name
		"chicken_id": 1,
		"name": null,
		"feather_color": null,
		"size": 1,
		"from_egg": 1,
		"coop_id": null,
		"favorite_food_id": null,
		"affection_meter": null,
		"sex": null,
		"alive_state": null
	}
  */
 // },
})

app.listen(port, ()=>{
	console.log('Server is listening on port number: $(port)');
})

