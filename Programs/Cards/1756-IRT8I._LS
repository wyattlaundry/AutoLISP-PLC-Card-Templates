
;-------------------------------------------------------------------------------
;InitVars()
;All important varaibles initialized here
;-------------------------------------------------------------------------------
(defun InitVars()

  	;Scale X - The Exact Spacing between each column
     	;Scale Y - The Exact Spacing between each row
     	;SHOULD (ideally) NOT BE CHANGED
     	(setq SCALEX 55.57)
     	(setq SCALEY 15.26)

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
   (setq rackSlotLabel (strcat "Rack " (itoa rack) " Slot " (itoa slot)))
   (TextInsert rackSlotLabel 60.1 79.3 "B" "BL")

   ;This loop goes through the IO List and draws the necessary blocks for each point
   ;Set for 16 points, numerous variable changes to work with other sizes
   (setq i 1)
   (repeat TOTAL_POINTS

     ;Get data for relative point
     (GetDataByPoint i)
     
     ;Draw TB Info
     (SetLayer "TB")
     (TextInsertByPoint iotype 39.7 17.7 "M")
     (TextInsertByPoint iotype 39.7 21.8 "M")
     (TextInsertByPoint iotype 39.7 25.7 "M")
     (TextInsertByPoint iotype 39.7 29.6 "M")

     ;Wire Information 1
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat "BLK\n" iotype "-" point "A") 50.75 28.6 "M")

     ;Wire Information 2
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat "WHT\n" iotype "-" point "B") 50.75 24.6 "M")

     ;Wire Information 3
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat "RED\n" iotype "-" point "C") 50.75 20.5 "M")

     ;Description
     (SetLayer "DESC")
     (TextInsertByPoint (strcat desc ) 20 30.1 "M")

     ;Tag
     (SetLayer "WIREINFO")
     (TextInsertByPoint tag 14.5 23.5 "M")

     ;Units
     (SetLayer "WIREINFO")
     (TextInsertByPoint (strcat EUmin " - " EUmax " " EUunits) 18 18.5 "M")
     
     ;Iteration incriment
     (setq i (+ i 1))  
     
   )  

  (princ)
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
  	(setq IG_Branch2 (strcat "IG" Tag "\n(THIS SH,A6)"))
  	(TextInsert IG 42.75 82.75 "M" "MC")
  	(TextInsert IG_Branch1 42.75 6.45 "M" "MC")
  	(TextInsert IG_Branch2  98.3 82.75 "M" "MC")    
	     
)