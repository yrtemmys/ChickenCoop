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

	con.end();
});

app.use(express.static('./static/'))

app.set('view engine', 'html')
app.set('views', './plublic')



app.get('/',(req, res)=>{
	res.sendFile('./static/index.html')
})


app.listen(port, ()=>{
	console.log('Server is listening on port number: $(port)');
})
