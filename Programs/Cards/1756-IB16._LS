;-------------------------------------------------------------------------------
;InitVars()
;All important varaibles initialized here
;-------------------------------------------------------------------------------
(defun InitVars()

  	;Scale X - The Exact Spacing between each column
     	;Scale Y - The Exact Spacing between each row
     	;SHOULD (ideally) NOT BE CHANGED
     	(setq SCALEX 65)
     	(setq SCALEY 8)

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
   (setq rackSlotLabel (strcat "Rack " (itoa rack) " Slot " (itoa slot)))
   (TextInsert rackSlotLabel 59.25 82.1 "B" "BL")

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
     (DrawTBInfo) ;Label for Right TB

     ;If data point is a spare, do nothing
     ;Otherwise, it draws Elements and wires.
     (cond 
     ((/= deviceID "SPARE")
      
	;Draw Devices
    	(SetLayer "DEVICE")
     	(InsertBlockByPoint devicePath 30 24)
 
     	;Wire Information 1
     	(SetLayer "WIREINFO")
     	(if (= fuseVal "0")
          (TextInsertByPoint (strcat wireColor "\n" iotype "-" point "C" ) 18 24 "M")
     	  (TextInsertByPoint (strcat wireColor "\n" iotype "-F" point ) 18 24 "M")
      	)

     	;Wire Information 2 & 3
     	(TextInsertByPoint (strcat wireColor "\n" iotype "-" point ) 43 24 "M")
     	(TextInsertByPoint (strcat wireColor "\n" iotype "-" point ) 50 24 "M")

      	;Draw Inner Wires
      	(SetLayer "INNERWIRE")
	(DrawLine 15 24 29 24)
  	(DrawLine 31 24 46 24)
     ))
     
     ;Iteration incriment
     (setq i (+ i 1))  
     
   )  

  (princ)
)

;-------------------------------------------------------------------------------
;DrawPower()                                                                    
;Draws all relevant title data                                                  
;-------------------------------------------------------------------------------
(defun DrawPower()

  	;Focus layer
	(SetLayer "POWER")

	;Delete Existing POWER data
	(Clear '((8 . "POWER")))

  	;Drawing VDC Labels
  	(setq Tag (GetCell "C3"))
	(setq S (GetCell "D3"))
	(setq L (GetCell "E3"))
	(setq VDC (strcat "24VDC-" Tag "\n(SH." S "," L ")"))
  	(setq VDC_Branch1 (strcat "24VDC-" Tag "\n(THIS SH,D4)"))
  	(setq VDC_Branch2 (strcat "24VDC-" Tag "\n(THIS SH,A8)"))
  	(TextInsert VDC 9.5 84 "M" "MC")
  	(TextInsert VDC_Branch1 10.5 12.5 "M" "MC")
  	(TextInsert VDC_Branch2 75.5 84 "M" "MC")

  	;COM Labels
	(setq Tag (GetCell "F3"))
	(setq S (GetCell "G3"))
	(setq L (GetCell "H3"))
  	(setq COM (strcat "24COM-" Tag "\n(SH." S "," L ")"))
  	(setq COM_Branch1 (strcat "24COM-" Tag "\n(THIS SH,D1)"))
  	(setq COM_Branch2 (strcat "24COM-" Tag "\n(THIS SH,A5)"))
  	(TextInsert COM 128 8.3 "M" "MC")
  	(TextInsert COM_Branch1 64 8 "M" "MC")
  	(TextInsert COM_Branch2 128 84 "M" "MC") 
	     
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

  	;Delete existing INNER WIRE
	(Clear '((8 . "INNERWIRE")))

  	;Delete existing WIREINFO objects
	(Clear '((8 . "WIREINFO")))

  	;Delete existing WIREINFO objects
	(Clear '((8 . "FUSE")))

  	;Delete existing TB objects
  	;Selects only text because actual TB is static
	(Clear '((0 . "MTEXT")(8 . "TB")))

	(princ)
)

;-------------------------------------------------------------------------------
;DrawFuseOrTB()                                                                 
;Draws Fuse  or TB (For the left)                                               
;-------------------------------------------------------------------------------

(defun DrawFuseOrTB(AMP)
  	
	(SetLayer "FUSE")
	(InsertBlockByPoint (DetermineFusePath AMP) 14 24)

  	(if (= AMP "0")

          ;If TB - (Point#)C
      	  (TextInsertByPoint (strcat point "C") 14 24 "M")

          ;If Fuse - (Amperage)A - F(Point#)
	  (progn
	  (TextInsertByPoint (strcat AMP "A") 14 24 "S")
     	  (TextInsertByPoint (strcat "F" point) 14 23 "M"))
	  
     	)
     	(TextInsertByPoint iotype 14 25 "M")
  
  	(princ)
  
)

;-------------------------------------------------------------------------------
;DrawTBInfo()                                                                   
;Draws TB Information                                                           
;-------------------------------------------------------------------------------

(defun DrawTBInfo()

	;Draw TB Info (Right TB)
  	;Custom MTEXT command because alignment is different
  	(SetLayer "TB")
  	(setq SHIFTX 46)
  	(setq SHIFTY 25)
     	(command "._mtext"
        (if (<= i (/ TOTAL_POINTS 2))
	  (strcat (itoa SHIFTX) "," (itoa(+ SHIFTY (* SCALEY (- (/ TOTAL_POINTS 2) i)))) ",0") 		  ;Left Device Coords
	  (strcat (itoa (+ SHIFTX SCALEX)) "," (itoa(+ SHIFTY (* SCALEY (- TOTAL_POINTS i)))) ",0") ;Right Device Coords
	)
	"_Justify" "ML"
	"_Style" "DWG_STYLE"
	"_Height" 2
	"_none" "@"
	iotype
	""
     )

  	(princ)
  
)

(princ);End of GetExcel.lsp