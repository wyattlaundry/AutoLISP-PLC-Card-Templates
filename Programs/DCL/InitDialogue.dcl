InitDialogue
 
: dialog
 
{
	label = "Template Dialogue Box";
 
	: row{
		: boxed_column {		
        		label = "&Pick Card";	
        		: row {	: text_part {label = "Rack";}
     				: popup_list {width = 14;key = "rack_sel";value = "0" ;}}
        		: row {	: text_part {label = "Slot";}
     				: popup_list {width = 14;key = "slot_sel";value = "1" ;}}
        	} 
        	:boxed_column {			
			label = "&Render Options";
        		:toggle {key = "dwg";label = "Load Drawing";}					
        		:toggle {key = "power";	label = "Load Power";}
			:toggle {key = "titleblock";label = "Load Title Block";}
        	}
        }

	ok_cancel;

	: row {					
 
     		: image {key = "im" ;height = 1.0 ;width = 1.0 ;}	
     		: paragraph {				
     			: text_part {label = "Designed and Created";}						
     			: text_part {label = "by Luke Lowery";}		
     		}						
     	}	
}