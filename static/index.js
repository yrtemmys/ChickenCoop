//let button = document.getElementById("button1")
//button.addEventListener("click", dothething)
//button.addEventListener("click", talkserver)

function dothething(){
	console.log("did it !!!!!!!!1111!")
}
let port = 7821
async function talkserver(){
	const result = await fetch("http://localhost:"+port+"/chicken")
	console.log(result)
}


let btn_feed = document.getElementById("btn_feed")
btn_feed.addEventListener("click", feed)
async function feed(){
	await fetch("http://localhost:"+port+"/feed/1/1")
}
let btn_lay = document.getElementById("btn_lay")
btn_lay.addEventListener("click", lay)
async function lay(){
	await fetch("http://localhost:"+port+"/lay/1")
}
let btn_hatch = document.getElementById("btn_hatch")
btn_hatch.addEventListener("click", hatch)
async function hatch(){
	let response = await fetch("http://localhost:"+port+"/select/egg_proper")
	let data = await response.json()
	let egg_id = data[0].values[0][0]
	await fetch("http://localhost:"+port+"/hatch/"+egg_id)

}
let btn_sell = document.getElementById("btn_sell")
btn_sell.addEventListener("click", sell)
async function sell(){
	await fetch("http://localhost:"+port+"/sell/2")
}

