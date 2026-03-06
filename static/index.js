let button = document.getElementById("button1")
//button.addEventListener("click", dothething)
button.addEventListener("click", talkserver)

function dothething(){
	console.log("did it !!!!!!!!1111!")
}

async function talkserver(){
	const result = await fetch("http://localhost:8080/chicken")
	console.log(result)
}
