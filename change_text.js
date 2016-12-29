//Takes current font-size/reading color scheme of the codex and changes it based on button press
$(document).ready(function() { 
  color_scheme_normal = true; 
  $('#increase_font').click(function(){    
      curSize= parseInt($('#text').css('font-size')) + 2;
  		if(curSize<=60)
  		{
  			$('#text').css('font-size', curSize);
  		}	
  });  
  $('#decrease_font').click(function(){   
  		curSize= parseInt($('#text').css('font-size')) - 2;
  		if(curSize>=12)
  		{
  			$('#text').css('font-size', curSize);
  		}
  });
  $('#change_color').click(function(){
  	if(color_scheme_normal)
  	{
  		document.body.style.backgroundColor = "black";
  		document.body.style.color = "white";
  		color_scheme_normal = false;
  	}
  	else
  	{
  		document.body.style.backgroundColor = "white";
  		document.body.style.color = "black";
  		color_scheme_normal = true;
  	}
  });

});
