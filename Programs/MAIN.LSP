;All File Paths are relative to the current open drawing

;LOCATION OF IO FILE - IO List must be in
(setq IOPath (strcat (getvar "dwgprefix") "..\\..\\IO_List.xlsx" ))

;Location of Card Programs
(setq ProgDir (strcat (getvar "dwgprefix") "..\\..\\Programs\\Cards\\" ))

;Location of common functions file
(setq FuncPath (strcat ProgDir "Functions"))

;Location of Symbols
(setq SymDir (strcat (getvar "dwgprefix") "..\\..\\Symbols\\" ))

(defun c:TEMPLATE ()

  	;Loading Dialogue
   	 (setq dcl_id (load_dialog (strcat (getvar "dwgprefix") "..\\..\\Programs\\\DCL\\InitDialogue.dcl" )))
    	 (if (not (new_dialog "InitDialogue" dcl_id))
	 	(exit)
    	 )

  	;Set Drop Down Options
  	(setq RACK_SEL "1")
  	(setq RACKS '("1" "2" "3" "4" "5" "6"))
	(start_list "rack_sel")				
	(mapcar 'add_list RACKS)				
	(end_list)

	(setq SLOT_SEL "1")
  	(setq SLOTS '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17"))
	(start_list "slot_sel")				
	(mapcar 'add_list SLOTS)				
	(end_list)

	;Cancel button Code 
	(action_tile
    		"cancel"						
    		"(done_dialog) (setq userclick nil)"		
	)

	;Ok Button Code  (Also handles Drop down box code and checkbox code)
	(action_tile
    		"accept"
		(strcat
		"(progn
		(setq RACK_SEL (atof (get_tile \"rack_sel\")))
		(setq SLOT_SEL (atof (get_tile \"slot_sel\")))
		(setq loadDWG (get_tile \"dwg\"))
		(setq loadPower (get_tile \"power\"))
		(setq loadTitleBlock (get_tile \"titleblock\"))"
    		"(done_dialog)(setq userclick T))")
	)


  	;Unloads DCL
	(start_dialog)
	(unload_dialog dcl_id)

  	;CODE AFTER GUI CLOSES
  	;Runs only if user hit 'ok'
 	(if userclick
	  	(progn

		  ;Load Common Functions
		  (load FuncPath "Failed to load Common Functions. Try again or debug")

		  ;Index Match for rack and slot
		  (setq RACK_SEL (fix RACK_SEL))
		  (setq RACK_SEL (nth RACK_SEL RACKS))

		  (setq SLOT_SEL (fix SLOT_SEL))
		  (setq SLOT_SEL (nth SLOT_SEL SLOTS))

		  ;Write Rack and Slot to excel
		  (WriteRackAndSlot RACK_SEL SLOT_SEL)

		  ;Loads Card Code
		  ;Note - Card File name must match field name
		  ;Reads after rack and slot has been inputted
		  (RequestCardType)
		  (load (strcat ProgDir cardtype) "Failed to load program. Try again or debug")

		  ;Determines what to render
		  ;These functions are loaded from 
		  (if (= loadDWG "1")(InitDWG RACK_SEL SLOT_SEL))
		  (if (= loadPower "1")(InitPower RACK_SEL SLOT_SEL))
		  (if (= loadTitleBlock "1")(InitTitle RACK_SEL SLOT_SEL))
		  
		) 
	)
 
	(princ)
 
)