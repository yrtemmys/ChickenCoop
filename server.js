let sql = require('mysql2')
let http = require('http')

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

let server = http.createServer((req, res)=>{
	res.writeHead(200, {'Content-Type':'text/html'})
	res.end('Hello World')
})

server.listen(port, ()=>{
	console.log('Server is listening on port number: $(port)');
})
