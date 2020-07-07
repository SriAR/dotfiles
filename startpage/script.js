document.addEventListener('DOMContentLoaded', function() {
	var randomNumber = Math.floor((Math.random() * 17) + 1);
	var randomBackground = randomNumber + ".jpg";
	console.log(randomNumber);

	document.querySelector("div#picture").style.backgroundImage = "url(src/a/" + randomBackground + ")";
	document.querySelector("div.background").style.backgroundImage = "url(src/a/" + randomBackground + ")";
	document.querySelector("input#search").classList.add("c" + randomNumber);
});

var focused = 1;


document.onkeydown = function(e) {

	var key = e.keyCode;
	var letter = String.fromCharCode(key);

	if ( document.activeElement.id == "search" ) { // If search bar and key [ESC], go back to blocks.
		if ( key == 27 ) {
			document.getElementById("search").value = '';
			document.activeElement.blur();
			document.getElementById(focused).focus();
		}
		return;
	}

	if (!document.activeElement.id) {
		switch (letter) {
			case ' ': document.getElementById("search").focus(); break;
			case 'D': window.open("https://www.reddit.com/r/DotA2", "_self"); break;
			case 'M': window.open("https://moodle.cmi.ac.in/login/index.php", "_self"); break;
			case 'G': window.open("https://www.gmail.com", "_self"); break;
			case 'S': window.open("https://www.youtube.com/user/WehSing/videos", "_self"); break;
			case 'W': window.open("https://web.whatsapp.com", "_self"); break;
			case 'Y': window.open("https://www.youtube.com", "_self"); break;
		}

		return;
	}
	var result = null;

};