import sql from "mysql2/promise";


const connection = await sql.createConnection({
	host: "localhost",
	user: "code",
	password: "pw",
	database: "chicken_coop"
});


export { connection as default }
