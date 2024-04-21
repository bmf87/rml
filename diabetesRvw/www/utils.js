// JS Functions for the R Shiny Diabetes Analysis app


/**
* 
* Get href of nav_panel[s] 
* Looking for where data-value="about"
*
**/
$(document).ready(function() {
  var navAnchors = $('a[href^="#tab-"]');
  var modelLink = $("#modelInfo");
  
  for (var i=0; i<navAnchors.length; i++) {
    if (navAnchors[i].getAttribute("data-value").includes("about")) {
      var href = navAnchors[i].getAttribute("href");
      var active_href = "javascript:clickNav('" + href +"')"; 
      //console.log(href);
      modelLink.attr("href", active_href);
    }
  }
    
});

// Click the About nav_panel
function clickNav(tab) {
  //console.log("Simulating click of " + tab)
  var navAnchor = $('a[href^="' + tab + '"]');
  navAnchor.click();
}

// Toggle Conditional Probability Plots on Main Tab
function togglePlots(id) {
  var link = $('#' + id);
  
  if(link.text() == 'Show Plots') {
    $("#agePDistribution").show();
    $("#BMIPDistribution").show();
    link.text('Hide Plots');
    return;
  }
  else if(link.text() == 'Hide Plots') {
    $("#agePDistribution").hide();
    $("#BMIPDistribution").hide();
    link.text('Show Plots');
    return;
  }
}