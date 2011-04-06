/*============================================================

Author: Simon Young
http://simonyoung.net
http://twitter.com/simon180

SCRIPT.JS 
Site specific JavaScript functionality

============================================================*/

$(document).ready(function () {

	// make links with rel=external open in new window/tab
	$(function() {
        $('a[rel*=external]').click( function() {
            window.open(this.href);
            return false;
        });
    });
    
    //retina display replacements yo!
    //$('img').retina();
	
});





















