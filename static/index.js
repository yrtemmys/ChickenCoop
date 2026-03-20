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
let txt_feed = document.getElementById("txt_feed").value
btn_feed.addEventListener("click", feed)
async function feed(){
	await fetch("http://localhost:"+port+"/feed/"+txt_feed+"/1")
}
let btn_lay = document.getElementById("btn_lay")
let txt_lay = document.getElementById("txt_lay").value
console.log(txt_lay.value)
btn_lay.addEventListener("click", lay)
async function lay(){
	let url = "http://localhost:"+port+"/lay/"+txt_lay
	console.log(url)
	await fetch(url)
}
let btn_hatch = document.getElementById("btn_hatch")
let txt_hatch = document.getElementById("txt_hatch").value
btn_hatch.addEventListener("click", hatch)
async function hatch(){
	let response = await fetch("http://localhost:"+port+"/select/egg_proper")
	let data = await response.json()
	let egg_id = data[0].values[0][0]
	await fetch("http://localhost:"+port+"/hatch/"+egg_id)

}
let btn_sell = document.getElementById("btn_sell")
let txt_sell = document.getElementById("txt_sell").value
btn_sell.addEventListener("click", sell)
async function sell(){
	await fetch("http://localhost:"+port+"/sell/"+txt_sell)
}

