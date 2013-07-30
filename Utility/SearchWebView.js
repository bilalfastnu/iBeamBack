// We're using a global variable to store the number of occurrences
var MyApp_SearchResultCount = 0;

function currentYPosition() {
    // Firefox, Chrome, Opera, Safari
    if (self.pageYOffset) return self.pageYOffset;
    // Internet Explorer 6 - standards mode
    if (document.documentElement && document.documentElement.scrollTop)
        return document.documentElement.scrollTop;
    // Internet Explorer 6, 7 and 8
    if (document.body.scrollTop) return document.body.scrollTop;
    return 0;
}

function smoothScroll(dest) {
    var startY = currentYPosition();
    //var stopY = elmYPosition(eID);
	var stopY = dest;
    var distance = stopY > startY ? stopY - startY : startY - stopY;
    if (distance < 100) {
        scrollTo(0, stopY); return;
    }
    var speed = Math.round(distance / 100);
    if (speed >= 20) speed = 20;
    var step = Math.round(distance / 25);
    var leapY = stopY > startY ? startY + step : startY - step;
    var timer = 0;
    if (stopY > startY) {
        for ( var i=startY; i<stopY; i+=step ) {
            setTimeout("window.scrollTo(0, "+leapY+")", timer * speed);
            leapY += step; if (leapY > stopY) leapY = stopY; timer++;
        } return;
    }
    for ( var i=startY; i>stopY; i-=step ) {
        setTimeout("window.scrollTo(0, "+leapY+")", timer * speed);
        leapY -= step; if (leapY < stopY) leapY = stopY; timer++;
    }
}


// helper function, recursively searches in elements and their child nodes
function MyApp_HighlightAllOccurencesOfStringForElement(element,keyword) {
  if (element) {
    if (element.nodeType == 3) {        // Text node
      while (true) {
        var value = element.nodeValue;  // Search for keyword in text node
        var idx = value.toLowerCase().indexOf(keyword);

        if (idx < 0) break;             // not found, abort

		  
        var span = document.createElement("span");
        var text = document.createTextNode(value.substr(idx,keyword.length));
        span.appendChild(text);
        span.setAttribute("class","MyAppHighlight");
        span.style.backgroundColor="yellow";
        span.style.color="black";
        text = document.createTextNode(value.substr(idx+keyword.length));
        element.deleteData(idx, value.length - idx);
        var next = element.nextSibling;
        element.parentNode.insertBefore(span, next);
        element.parentNode.insertBefore(text, next);
        element = text;
        MyApp_SearchResultCount++;	// update the counter
		  
		
		  var x = 0;
		  var y = 0;
		  var width = span.offsetWidth;
		  var height = span.offsetHeight;
		  do {
			  x += span.offsetLeft;
			  y += span.offsetTop;
		  } while (span = span.offsetParent);
		  
		/* 
		  //var node = element.nodeValue;
		  var x = 0;
		  var y = 0;
		  
		  var width = element.parentNode.offsetWidth;
		  var height = element.parentNode.offsetHeight;

		  do {
			  x += element.parentNode.offsetLeft;
			  y += element.parentNode.offsetTop;
		  } while (element = element.parentNode.offsetParent);
		  
		 */ 
		  window.location = "coord:" + x +":"+ y +":"+ width +":"+ height;
		  
		  //window.location = "/allCorrect/" + x + ":" + y + ":"+ width + ":"+ height + ":Count:" + MyApp_SearchResultCount;
		  //window.scrollTo(x,y);
		  smoothScroll(y);
		  
      }
    } else if (element.nodeType == 1) { // Element node
      if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
        for (var i=element.childNodes.length-1; i>=0; i--) {
          MyApp_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
        }
      }
    }
  }
}

// the main entry point to start the search
function MyApp_HighlightAllOccurencesOfString(keyword) {
  MyApp_RemoveAllHighlights();
  MyApp_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
	

}

// helper function, recursively removes the highlights in elements and their childs
function MyApp_RemoveAllHighlightsForElement(element) {
  if (element) {
    if (element.nodeType == 1) {
      if (element.getAttribute("class") == "MyAppHighlight") {
        var text = element.removeChild(element.firstChild);
        element.parentNode.insertBefore(text,element);
        element.parentNode.removeChild(element);
        return true;
      } else {
        var normalize = false;
        for (var i=element.childNodes.length-1; i>=0; i--) {
          if (MyApp_RemoveAllHighlightsForElement(element.childNodes[i])) {
            normalize = true;
          }
        }
        if (normalize) {
          element.normalize();
        }
      }
    }
  }
  return false;
}

// the main entry point to remove the highlights
function MyApp_RemoveAllHighlights() {
  MyApp_SearchResultCount = 0;
  MyApp_RemoveAllHighlightsForElement(document.body);
}

var selectedText = "";

function getTextOffset() {
    var text = window.getSelection();
    //selectedText = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset - text.anchorOffset);
    return text.anchorOffset +":"+ text.focusOffset;
}

