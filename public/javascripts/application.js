$(function () {  
  $('#reports th a').live('click', function () {  
    $.getScript(this.href);  
    return false;  
  });  

  $('a#CB-qrcode-multiple').click(function(e){
    alert("test"); 
    return false;
  })
})
