panel = function(el, show, hide) {
    document.getElementById(hide).style.display = "none";
    document.getElementById(show).style.display = "block";
    
    var x = document.querySelectorAll('nav ul li');
    x.forEach(function(i){
            i.firstChild.style.fontWeight = "normal";
        }
    )
    el.style.fontWeight = "bold";
   
}

const dropdown = document.querySelector('.dropdown');
dropdown.addEventListener('change', (changeOutput) => {
    document.getElementById('inputs').style.display="none";
    document.getElementById('output').style.display="block";

    document.getElementById('outputsA').style.fontWeight="bold";
    document.getElementById('inputsA').style.fontWeight="normal";

    document.querySelector('.outputimg').src = "images/fig4.png";
});

console.log('starting fetch');

// const response = await fetch('http://localhost:8080/JSON/output.json');
// const json = await response.json();
// console.log(JSON.stringify(json)); 

fetch('http://localhost:8080/JSON/output.json').then(response => {
    console.log(response);
    return response.blob;
}).then(response => {
    console.log(response.blob);
});