;-------------------------------------------------------------------------------
;InitVars()
;All important varaibles initialized here
;-------------------------------------------------------------------------------
(defun InitVars()

  	;Scale X - The Exact Spacing between each column
     	;Scale Y - The Exact Spacing between each row
     	;SHOULD (ideally) NOT BE CHANGED
     	(setq SCALEX 60.55)
     	(setq SCALEY 7.0925)

  	;Number of poitns for specific Drawing
  	(setq TOTAL_POINTS 16)

)

;-------------------------------------------------------------------------------
;DrawContent()           (Main Program kinda)                                   
;Draws the "body" of the drawing                                                
;-------------------------------------------------------------------------------
(defun DrawContent ()
  
   ;Clear Existing Blocks
   (ClearContent)

   ;Draw rack Alot Label
   (SetLayer "TEXT")
   (setq rackSlotLabel (strcat "Rack " RACK_SEL " Slot " SLOT_SEL))
   (TextInsert rackSlotLabel 20 77 "B" "BL")

   ;This loop goes through the IO List and draws the necessary blocks for each point
   ;Set for 16 points, numerous variable changes to work with other sizes
   (setq i 1)
   (repeat TOTAL_POINTS

     ;Get data for relative point
     (GetDataByPoint i)

     ;Set file path for each data type
     (setq devicePath (DetermineDevicePath deviceID))

     ;TB are drawn for all points
     (DrawFuseOrTB fuseVal) ;Will draw a TB for a spare since fuseVal will be 0 (ideally)
     
     ;draws Elements and wires.
     (DrawElements)
     
     ;Iteration incriment
     (setq i (+ i 1))  
     
   )  

  (princ)
)


;-------------------------------------------------------------------------------
;DrawPower()                                                                    
;Draws all relevant power data                                                  
;-------------------------------------------------------------------------------
(defun DrawPower()

  	;Focus layer
	(SetLayer "POWER")

	;Delete Existing POWER data
	(Clear '((8 . "POWER")))

  	;Delete Existing WIREINFO data ------------------------------- CHANGE????
	(Clear '((8 . "WIREINFO")))


  	;Drawing VDC Labels
  	(setq Tag (GetCell "C3"))
	(setq S (GetCell "D3"))
	(setq L (GetCell "E3"))
	(setq VDC (strcat "24VDC-" Tag "\n(SH." S "," L ")"))
  	(setq VDC_Branch1 (strcat "24VDC-" Tag "\n(THIS SH,D4)"))
  	(setq VDC_Branch2 (strcat "24VDC-" Tag "\n(THIS SH,A8)"))
  	(TextInsert VDC 7 80 "M" "MC")
  	(TextInsert VDC_Branch1 7 13.5 "M" "MC")
  	(TextInsert VDC_Branch2 69.75 83 "M" "MC")

  	;Draw COM labels
	(setq Tag (GetCell "F3"))
	(setq S (GetCell "G3"))
	(setq L (GetCell "H3"))
  	(setq COM (strcat "24COM-" Tag "\n(SH." S "," L ")"))
  	(setq COM_Branch1 (strcat "24COM-" Tag "\n(THIS SH,D4)"))
  	(setq COM_Branch2 (strcat "24COM-" Tag "\n(THIS SH,A8)"))
  	(TextInsert COM 10.5 80 "M" "MC")
  	(TextInsert COM_Branch1 10.5 17 "M" "MC")
  	(TextInsert COM_Branch2 74 83 "M" "MC")

  	;Relay COM
  	(setq COM (strcat "24COM-" Tag "\n(SH." S "," L ")"))
  	(setq COM_Branch1 (strcat "24COM-" Tag "\n(THIS SH,D3)"))
  	(setq COM_Branch2 (strcat "24COM-" Tag "\n(THIS SH,A7)"))
  	(TextInsert COM 25.5 74.5 "M" "MC")
  	(TextInsert COM_Branch1 25.5 11.75 "M" "MC")
  	(TextInsert COM_Branch2 86 80 "M" "MC")


  	;Individual COM Wire info
 	(setq i 1)
  	(repeat TOTAL_POINTS
	  (TextInsertByPoint (strcat "24COM-" Tag) 28 18.75 "M")
	  (setq i (+ i 1))
	)
    
	     
) 


;-------------------------------------------------------------------------------
;ClearContent()                                                                     
;Clears all pre-existing blocks-symbols that are to be displayed.               
;Program selects all objects on indicated layers, and earases them              
;-------------------------------------------------------------------------------
(defun ClearContent()

  	;Delete existing DEVICE objects
	(Clear '((8 . "DEVICE")))

  	;Delete Rack Slot Label
  	(Clear '((8 . "TEXT")(7 . "DWG_STYLE_BOLD")))

  	;Delete existing WIREINFO objects
	(Clear '((8 . "WIREINFO")))

  	;Delete existing DESC objects
	(Clear '((8 . "DESC")))

  	;Delete existing TB objects
  	;Selects only text because actual TB is static
	(Clear '((0 . "MTEXT")(8 . "TB")))

  	;Delete existing INNER WIRE
	(Clear '((8 . "INNERWIRE")))

  	;Delete existing WIREINFO objects
	(Clear '((8 . "FUSE")))

	(princ)
)

;-------------------------------------------------------------------------------
;Draw Elements()                                                                
;Draws symbols associated with excel data                                       
;Exact spacing and location are located here - no varaibles bc there are a lot  
;Isolated in case of Spare, drawing is not needed                               
;-------------------------------------------------------------------------------

(defun DrawElements()
  
     ;Draw Devices
     (cond 
     ((/= deviceID "SPARE")(SetLayer "DEVICE")(InsertBlockByPoint devicePath 44 22.12))
     (t (SetLayer "INNERWIRE")(DrawLine 43 22.1 45 22.1))
     )

     ;Wire Information 1
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat wireColor "\n" iotype "-R" point "-14" ) 39 22.1 "S")

     ;Wire Information 2
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat wireColor "\n" iotype "-R" point "-11") 39 20.35 "S")

     ;Wire Information 3
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat wireColor "\n" iotype "-" point ) 50 22.1 "S")

     ;Wire Information 4
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat iotype "-" point ) 21.7 21.75 "M")

     ;Desc
     (SetLayer "DESC")
     (TextInsertByPoint (strcat desc ) 63 22.25 "M")
    
)  

;-------------------------------------------------------------------------------
;DrawWires()                                                                    
;Just Draws Wires                                                               
;-------------------------------------------------------------------------------

(defun DrawWires()

  	(SetLayer "INNERWIRE")
	(DrawLine 15 24 29 24)
  	(DrawLine 31 24 46 24)
  
)

;-------------------------------------------------------------------------------
;DrawFuseOrTB()                                                                 
;Draws Fuse  or TB (For the left)                                               
;-------------------------------------------------------------------------------

(defun DrawFuseOrTB(AMP)
  	
	(SetLayer "FUSE")
	(InsertBlockByPoint (DetermineFusePath AMP) 55 22.12)

  	(if (= AMP "0")

          ;If TB - (Point#)C
      	  (TextInsertByPoint (strcat point "C") 55 22.12 "M")

          ;If Fuse - (Amperage)A - F(Point#)
	  (progn
	  (TextInsertByPoint (strcat AMP "A") 55 22.12 "S")
     	  (TextInsertByPoint (strcat "F" point) 55 21.3 "M"))
	  
     	)
     	(TextInsertByPoint (strcat iotype) 55 23 "M")
  
  	(princ)
  
)

;-------------------------------------------------------------------------------
;DrawLine()                                                                     
;Standardizes drawling lines and makes it look cleaner in code                  
;Just a line command                                                            
;-------------------------------------------------------------------------------

(defun DrawLine(X1 Y1 X2 Y2)

	(command "._line"
		 (if (<= i 8)
	  		(strcat (rtos X1) "," (rtos(+ Y1 (* SCALEY (- 8 i)))) ",0") 		  ;Left Device Coords
	 		(strcat (rtos (+ X1 SCALEX)) "," (rtos(+ Y1 (* SCALEY (- 16 i)))) ",0") ;Right Device Coords
	         )
		 (if (<= i 8)
	  		(strcat (rtos X2) "," (rtos(+ Y2 (* SCALEY (- 8 i)))) ",0") 		  ;Left Device Coords
	 		(strcat (rtos (+ X2 SCALEX)) "," (rtos(+ Y2 (* SCALEY (- 16 i)))) ",0") ;Right Device Coords
	         )
		 ""
	)

)  

(princ);End of GetExcel.lsp