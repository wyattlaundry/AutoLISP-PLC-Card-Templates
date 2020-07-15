;-------------------------------------------------------------------------------
;InitVars()
;All important varaibles initialized here
;-------------------------------------------------------------------------------
(defun InitVars()

  	;Scale X - The Exact Spacing between each column
     	;Scale Y - The Exact Spacing between each row
     	;SHOULD (ideally) NOT BE CHANGED
     	(setq SCALEX 62.55)
     	(setq SCALEY 7.35)

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
   (command "_.layer" "s" "TEXT" "")
   (setq rackSlotLabel (strcat "Rack " RACK_SEL " Slot " SLOT_SEL))
   (TextInsert rackSlotLabel 58.35 75.5 "B" "BL")

   ;This loop goes through the IO List and draws the necessary blocks for each point
   ;Set for 16 points, numerous variable changes to work with other sizes
   (setq i 1)
   (repeat TOTAL_POINTS

     ;Get data for relative point
     (GetDataByPoint i)

     ;TB are drawn for all points
     (DrawFuseOrTB fuseVal) ;Will draw a TB for a spare since fuseVal will be 0 (ideally)
     
     ;Wire Information 4
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat iotype"-" point ) 49.3 21.2 "M")

     ;Description
     (SetLayer "DESC")
     (TextInsertByPoint (strcat desc ) 12 23 "M")

     ;Tag and Units
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat tag "\n" EUmin " - " EUmax " " EUunits) 18.5 19.75 "M")
     
     ;Iteration incriment
     (setq i (+ i 1))  
     
   )  

  (princ)
)

;-------------------------------------------------------------------------------
;DrawTitle()                                                                    
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
  	(setq VDC_Branch1 (strcat "24VDC-" Tag "\n(THIS SH,D2)"))
  	(setq VDC_Branch2 (strcat "24VDC-" Tag "\n(THIS SH,A6)"))
  	(TextInsert VDC 42 80 "M" "MC")
  	(TextInsert VDC_Branch1 45.9 14.25 "M" "MC")
  	(TextInsert VDC_Branch2 108.25 81.5 "M" "MC")

  	;Draw COM labels
	(setq Tag (GetCell "F3"))
	(setq S (GetCell "G3"))
	(setq L (GetCell "H3"))
  	(setq COM (strcat "24COM-" Tag "\n(SH." S "," L ")"))
  	(setq COM_Branch1 (strcat "24COM-" Tag "\n(THIS SH,D1)"))
  	(setq COM_Branch2 (strcat "24COM-" Tag "\n(THIS SH,A5)"))
  	(TextInsert COM 122 13 "M" "MC")
  	(TextInsert COM_Branch1 59.5 13 "M" "MC")
  	(TextInsert COM_Branch2 122 81 "M" "MC")

  	;Draw IG labels
	(setq Tag (GetCell "I3"))
	(setq S (GetCell "J3"))
	(setq L (GetCell "K3"))
  	(setq IG "ISOLATED GROUND BAR")
  	(setq IG_Branch1 (strcat "IG" "\n(THIS SH,D2)"))
  	(setq IG_Branch2 (strcat "IG" "\n(THIS SH,A6)"))
  	(TextInsert IG 105 16 "M" "MC")
  	(TextInsert IG_Branch1 42.75 12.75 "M" "MC")
  	(TextInsert IG_Branch2 105.25 79.5 "M" "MC")
	     
) 

;-------------------------------------------------------------------------------
;ClearContent()                                                                 
;Clears all pre-existing blocks-symbols that are to be displayed.               
;Program selects all objects on indicated layers, and earases them              
;-------------------------------------------------------------------------------
(defun ClearContent()

  	;Delete Rack Slot Label
  	(Clear '((8 . "TEXT")(7 . "DWG_STYLE_BOLD")))

  	;Delete existing WIREINFO objects
	(Clear '((8 . "WIREINFO")))

  	;Delete existing TB objects
  	;Selects only text because actual TB is static
	(Clear '((0 . "MTEXT")(8 . "TB")))
  
  	;Delete existing FUSE objects
	(Clear '((8 . "FUSE")))

  	;Delete existing DESC objects
	(Clear '((8 . "DESC")))

	(princ)
)

;-------------------------------------------------------------------------------
;DrawFuseOrTB()                                                                 
;Draws Fuse  or TB (For the left)                                               
;-------------------------------------------------------------------------------

(defun DrawFuseOrTB(AMP)

  	(setq fX 39.48)
  	(setq fY 23.75)
  	
	(SetLayer "FUSE")
	(InsertBlockByPoint (DetermineFusePath AMP) fX fY)

  	(if (= AMP "0")

          ;If TB - (Point#)C
      	  (TextInsertByPoint (strcat point "C") fX fY "M")

          ;If Fuse - (Amperage)A - F(Point#)
	  (progn
	  (TextInsertByPoint (strcat AMP "A") fX fY "S")
     	  (TextInsertByPoint (strcat "F" point) fX (- fY 0.82) "M"))
	  
     	)
     	(TextInsertByPoint (strcat iotype "-" point) fX (+ fY 0.88) "M")
  
  	(princ)
  
)

(princ);End of GetExcel.lsp