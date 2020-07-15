;-------------------------------------------------------------------------------
;InitVars()
;All important varaibles initialized here
;-------------------------------------------------------------------------------
(defun InitVars()

  	;Scale X - The Exact Spacing between each column
     	;Scale Y - The Exact Spacing between each row
     	;SHOULD (ideally) NOT BE CHANGED
     	(setq SCALEX 66)
     	(setq SCALEY 16)

  	;Number of poitns for specific Drawing
  	(setq TOTAL_POINTS 8)

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
   (setq rackSlotLabel (strcat "Rack " (itoa RACK_SEL) " Slot " (itoa SLOT_SEL)))
   (TextInsert rackSlotLabel 10 81.5 "B" "BL")

   ;This loop goes through the IO List and draws the necessary blocks for each point
   ;Set for 16 points, numerous variable changes to work with other sizes
   (setq i 1)
   (repeat TOTAL_POINTS

     ;Get data for relative point - Functions.lsp
     (GetDataByPoint i)

     ;TB IO Desc
     (SetLayer "TB")
     (TextInsertByPoint iotype 32.5 16 "M")
     (TextInsertByPoint iotype 32.5 20 "M")
     (TextInsertByPoint iotype 32.5 24 "M")
     
     ;Wire Information 1
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat "BL\n" iotype "-" point "+" ) 27.5 23 "M")

     ;Wire Information 2
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat "BL\n" iotype "-" point "-") 27.5 19 "M")

     ;Desc
     (SetLayer "DESC")
     (TextInsertByPoint (strcat desc ) 57.5 25 "M")

     ;Tag and Units
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat tag "\n" EUmin " - " EUmax " " EUunits) 57.5 16.25 "M")
     
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

	;Draw IG labels
	(setq Tag (GetCell "I3"))
	(setq S (GetCell "J3"))
	(setq L (GetCell "K3"))
  	(setq IG "ISOLATED GROUND BAR")
  	(setq IG_Branch1 (strcat "IG" Tag "\n(THIS SH,D3)"))
  	(setq IG_Branch2 (strcat "IG" Tag "\n(THIS SH,A7)"))
  	(TextInsert IG 101.5 10 "M" "MC")
  	(TextInsert IG_Branch1 35.5 12.5 "M" "MC")
  	(TextInsert IG_Branch2 101.5 80.5 "M" "MC")    
	     
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

  	;Delete existing DESC objects
	(Clear '((8 . "DESC")))

  	;Delete existing TB objects
  	;Selects only text because actual TB is static
	(Clear '((0 . "MTEXT")(8 . "TB")))

	(princ)
)

(princ);End of GetExcel.lsp