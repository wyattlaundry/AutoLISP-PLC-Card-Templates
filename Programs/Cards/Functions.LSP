;--------------------------------------------------------------------
;          MY ADDED FUNCTIONS THAT ALL PROGRAMS USE                  
;--------------------------------------------------------------------

;-------------------------------------------------------------------------------
;InitAll()                                                                      
;Ruins all 3 init commands    dwg, power, title                                 
;-------------------------------------------------------------------------------
(defun InitAll(RACK_SEL SLOT_SEL)

	;Settings that allow console interatction
   	(setq oldattreq (getvar "attreq"))
   	(setvar "attreq" 0)

  	;Settings that remove snapping bug
  	(setq oldsnap (getvar "osmode"))
	(setvar "osmode" 0)

  	;Initialize varaibles
  	(InitVars)

  	;Get Content And Draw
   	(RequestData "IO" 26 17)
	(DrawContent)

  	;Get Title Info And Draw
	(RequestData "TitleBlock" 15 50)
  	(DrawTitle)

  	;Get Power and Draw
	(RequestData "Power" 11 50)
  	(DrawPower)

  	;Reset Settgins when done
  	(setvar "attreq" oldattreq)
  	(setvar "osmode" oldsnap)
  
	(princ)  

)  


;-------------------------------------------------------------------------------
;InitDWG()
;COMMAND CALLED BY USER - STARTS INSERTION PROCESS OF DWG DATA                  
;-------------------------------------------------------------------------------
(defun InitDWG(RACK_SEL SLOT_SEL)

  	;Settings that allow console interatction
   	(setq oldattreq (getvar "attreq"))
   	(setvar "attreq" 0)

  	;Settings that remove snapping bug
  	(setq oldsnap (getvar "osmode"))
	(setvar "osmode" 0)

  	;Initialize varaibles
  	(InitVars)

  	;Inputting Necessary Cols and Rows
   	(RequestData "IO" 30 17)

  	;DRAWS CONTENT
	(DrawContent)

  	;Reset Settgins when done
  	(setvar "attreq" oldattreq)
  	(setvar "osmode" oldsnap)
  
	(princ)  	
)

;-------------------------------------------------------------------------------
;InitTitle()                                                                    
;COMMAND CALLED BY USER - STARTS INSERTION PROCESS OF TITLE DATA                
;-------------------------------------------------------------------------------
(defun InitTitle(RACK_SEL SLOT_SEL)

  	;Settings that allow console interatction
   	(setq oldattreq (getvar "attreq"))
   	(setvar "attreq" 0)

  	;Settings that remove snapping bug
  	(setq oldsnap (getvar "osmode"))
	(setvar "osmode" 0)

  	;Initialize varaibles
  	(InitVars)

  	;Inputting Necessary Cols and Rows
	(RequestData "TitleBlock" 15 50)

  	;Draws Title Information
  	(DrawTitle)

  	;Reset Settgins when done
  	(setvar "attreq" oldattreq)
  	(setvar "osmode" oldsnap)

)

;-------------------------------------------------------------------------------
;InitPower()                                                                    
;COMMAND CALLED BY USER - STARTS INSERTION PROCESS OF POWER DATA                
;-------------------------------------------------------------------------------
(defun InitPower(RACK_SEL SLOT_SEL)

  	;Settings that allow console interatction
   	(setq oldattreq (getvar "attreq"))
   	(setvar "attreq" 0)

  	;Settings that remove snapping bug
  	(setq oldsnap (getvar "osmode"))
	(setvar "osmode" 0)

  	;Initialize varaibles
  	(InitVars)

  	;Inputting Necessary Cols and Rows
	(RequestData "Power" 11 50)

  	;Draws Power Objects
  	(DrawPower)
  
  	;Reset Settgins when done
  	(setvar "attreq" oldattreq)
  	(setvar "osmode" oldsnap)

)

;-------------------------------------------------------------------------------
;RequestData()                                                                  
;Gets data from excel given sheet name, rows, and columns                       
;-------------------------------------------------------------------------------
(defun RequestData(SHEET COLS ROWS)

   	;Import and initialize IO List Data
  	;Row and Columns are arbitrary, they just need to exceed bounds of (necessary) data
  	(GetExcel IOPath SHEET (strcat (Number2Alpha COLS)(itoa ROWS)))
  
	(princ)
)

;-------------------------------------------------------------------------------
;RequestData()                                                                  
;Gets data from excel given sheet name, rows, and columns                       
;-------------------------------------------------------------------------------
(defun RequestCardType()

   	;Get access to card field
  	(GetExcel IOPath "IO" "T2")
  	(setq cardtype (GetCell "T2"))

  	(cond
	((= cardtype "0")(princ "NO CARD TYPE WAS DEFINED"))
	)

	(princ)
)

;-------------------------------------------------------------------------------
;GetRackAndSlot()                                                            
;Writes to excel file for rack and slot - requires user input                   
;-------------------------------------------------------------------------------
(defun WriteRackAndSlot(rack slot)

  	;Update Excel with new values
  	(OpenExcel IOPath "IO" nil)
  	(PutCell "N2" rack)
  	(PutCell "N3" slot)
  	(CloseExcel IOPath)

)

;-------------------------------------------------------------------------------
;GetDataByPoint()                                                               
;Gets data for each iteration of loop                                           
;-------------------------------------------------------------------------------
(defun GetDataByPoint (iter)

	(setq iotype (GetCell "P2"))
     	(setq rack (GetCell (strcat "Q" (itoa (+ iter 1)))))
     	(setq slot (GetCell (strcat "R" (itoa (+ iter 1)))))
     	(setq point (GetCell (strcat "S" (itoa (+ iter 1)))))
  	(setq cardType (GetCell (strcat "T" (itoa (+ iter 1)))))
     	(setq fuseVal (GetCell (strcat "U" (itoa (+ iter 1)))))
     	(setq deviceID (GetCell (strcat "V" (itoa (+ iter 1)))))
     	(setq tag (GetCell (strcat "W" (itoa (+ iter 1)))))
     	(setq EUmin (GetCell (strcat "X" (itoa (+ iter 1)))))
     	(setq EUmax (GetCell (strcat "Y" (itoa (+ iter 1)))))
     	(setq EUunits (GetCell (strcat "Z" (itoa (+ iter 1)))))
     	(setq wireColor (GetCell (strcat "AA" (itoa (+ iter 1)))))
  	(setq desc (GetCell (strcat "AB" (itoa (+ iter 1)))))
       
)

;-------------------------------------------------------------------------------
;DrawTitle()                                                                    
;Draws all relevant title data                                                  
;-------------------------------------------------------------------------------
(defun DrawTitle()

  	;Clear all previous Title and Rev Objects
  	(ClearTitle)

  	;Focus layer
	(SetLayer "TITLE")

  	;Drawn By
	(setq drawnBy (GetCell "B3"))
	(TextInsert drawnBy 124.4 5.15 "TITLE_L" "BL") 

  	;Date
	(setq date (GetCell "C3"))
	(TextInsert date 128.6 5.15 "TITLE_L" "BL") 

  	;Drawing Number
  	(setq drawingNo (GetCell "K15"))
	(TextInsert drawingNo 123.5 3.3 "TITLE_L" "BL")

	;Project Name
  	(setq projName (GetCell "E3"))
	(TextInsert projName 115 5 "TITLE_L" "MC") 
  
  	;Drawing Description
  	(setq drawingDesc (GetCell "M15"))
	(TextInsert drawingDesc 115 3.3 "TITLE_L" "MC") 

  	;Current Sheet
  	(setq currentSheet (GetCell "L15"))	
	(TextInsert currentSheet 125.25 2.4 "TITLE" "BL")

  	;Total Sheets
  	(setq totalSheets (GetCell "B6"))
  	(TextInsert totalSheets 128.5 2.4 "TITLE" "BL")

  	;Rev
  	(setq currentRev (GetCell "D6"))
  	(TextInsert currentRev 132 3 "TITLE_L" "BL")

  	;Rev focus layer
	(SetLayer "REV")

  	;Drawing all rev data
  	(setq i 0)
	(repeat 4

	  	(setq rNo (GetCell (strcat "B" (itoa (+ 9 i)))))
	  	(TextInsert rNo 63 (+ 2.9 (* i 0.75)) "TITLE_L" "BL")

	  	(setq rRev (GetCell (strcat "C" (itoa (+ 9 i)))))
	  	(TextInsert rRev 64.3 (+ 2.9 (* i 0.75)) "TITLE_L" "BL")

	  	(setq rDate (GetCell (strcat "D" (itoa (+ 9 i)))))
	  	(TextInsert rDate 71.75 (+ 2.9 (* i 0.75)) "TITLE" "BL")

	  	(setq rBy (GetCell (strcat "E" (itoa (+ 9 i)))))
	  	(TextInsert rBy 74.6 (+ 2.9 (* i 0.75)) "TITLE_L" "BL")

	  	(setq rChkd (GetCell (strcat "F" (itoa (+ 9 i)))))
	  	(TextInsert rChkd 76.4 (+ 2.9 (* i 0.75)) "TITLE_L" "BL")

	  	(setq rAppr (GetCell (strcat "G" (itoa (+ 9 i)))))
	  	(TextInsert rAppr 78.2 (+ 2.9 (* i 0.75)) "TITLE_L" "BL")
	  
		(setq i (+ i 1))
	)  

)

;-------------------------------------------------------------------------------
;ClearTitle()                                                                   
;Clears all pre-existing blocks-symbols that are to be displayed.               
;Program selects all objects on indicated layers, and earases them              
;-------------------------------------------------------------------------------
(defun ClearTitle()

  	;Delete Existing TITLE data
  	(Clear '((8 . "TITLE")))

  	;Delete Rev data (and not rev headers)
  	(Clear '((8 . "REV")
			(-4 . "<NOT")(1 . "NO.")(-4 . "NOT>") 
			(-4 . "<NOT")(1 . "REVISION")(-4 . "NOT>")
			(-4 . "<NOT")(1 . "DATE")(-4 . "NOT>")
			(-4 . "<NOT")(1 . "BY")(-4 . "NOT>")
			(-4 . "<NOT")(1 . "CHKD")(-4 . "NOT>")
			(-4 . "<NOT")(1 . "APPRD")(-4 . "NOT>")
	))

)

;-------------------------------------------------------------------------------
;TextInsert()                                                                   
;Standardizes title information insertion                                       
;-------------------------------------------------------------------------------
(defun TextInsert(TEXT X Y Font Align)

	(command "._mtext"
		 (strcat (rtos X) "," (rtos Y))
		 "_Justify" Align
	         "_Style" (GetFont Font)
		 "_Width" 10
		 TEXT
		 ""
    	)

)

;-------------------------------------------------------------------------------
;TextInsertByPoint()                                                            
;Standardizes the MText for labels                                              
;S - Small      M - Medium        B- BOLD                                       
;Uses global varaible 'i' to determine current iteration.                       
;-------------------------------------------------------------------------------
(defun TextInsertByPoint(Text SHIFTX SHIFTY Font)
  (command "._mtext"
        (if (<= i (/ TOTAL_POINTS 2))
	  (strcat (rtos SHIFTX) "," (rtos(+ SHIFTY (* SCALEY (- (/ TOTAL_POINTS 2) i)))) ",0") 		  ;Col 1 Coords
	  (strcat (rtos (+ SHIFTX SCALEX)) "," (rtos(+ SHIFTY (* SCALEY (- TOTAL_POINTS i)))) ",0") ;Col 2 Coords
	)
	"_Justify" "MC"
	"_Style" (GetFont Font)
	"_Height" 2
	"_none" "@"
	Text
	""
     )
  (princ)
)

;-------------------------------------------------------------------------------
;InsertBlockByPoint()                                                           
;Standardizes the input command for blocks                                      
;Takes in a file path, and the reference point from which to draw.              
;Uses global varaible 'i' to determine current iteration.                       
;-------------------------------------------------------------------------------
(defun InsertBlockByPoint(FPath SHIFTX SHIFTY)
  (command "_.insert"    
        FPath   
        (if (<= i (/ TOTAL_POINTS 2))
	  (strcat (rtos SHIFTX) "," (rtos(+ SHIFTY (* SCALEY (- (/ TOTAL_POINTS 2) i)))) ",0") 		  ;Left Device Coords
	  (strcat (rtos (+ SHIFTX SCALEX)) "," (rtos(+ SHIFTY (* SCALEY (- TOTAL_POINTS i)))) ",0") ;Right Device Coords
	)
        "1"        ;x scale
        "1"        ;y scale
        "0"        ;rotation
     )
)

;-------------------------------------------------------------------------------
;DetermineFusePath()
;Given an amperage it picks wheter to use terminal block or a fuse
;-------------------------------------------------------------------------------
(defun DetermineFusePath(AMP)
  
	(cond
	   ;FUSEPATHS
	   ((= AMP "0")(strcat SymDir "WIDE_TB.dwg"))
	   ((= AMP " ")(strcat SymDir "WIDE_TB.dwg"))
	   (t (strcat SymDir "FUSE1.dwg"))
	 )

  
)

;-------------------------------------------------------------------------------
;DetermineDevicePath()                                                          
;DetermineFusePath()                                                            
;These function take in their respective IDs/Values and return the appropriate  
;file name to use.                                                              
;Default paths returned can be changed - slighly arbitrary                      
;-------------------------------------------------------------------------------
(defun DetermineDevicePath(ID)
  
	(cond
	  ;DEVICE PATHS
	  ((=  ID "FUSE") (strcat SymDir "FUSE1.dwg"))
	  ((=  ID "INDICATOR_LIGHT") (strcat SymDir "INDICATOR_LIGHT.dwg"))
	  ((=  ID "KEY_LOCK") (strcat SymDir "KEY_LOCK.dwg"))
	  ((=  ID "LEVEL_SWITCH_NC") (strcat SymDir "LEVEL_SWITCH_NC.dwg"))
	  ((=  ID "LEVEL_SWITCH_NO") (strcat SymDir "LEVEL_SWITCH_NO.dwg"))
	  ((=  ID "LIMIT_SWITCH_NC") (strcat SymDir "LIMIT_SWITCH_NC.dwg"))
	  ((=  ID "LIMIT_SWITCH_NO") (strcat SymDir "LIMIT_SWITCH_NO.dwg"))
	  ((=  ID "PRESSURE_SWITCH_HIGH") (strcat SymDir "PRESSURE_SWITCH_HIGH.dwg"))
	  ((=  ID "PRESSURE_SWITCH_LOW") (strcat SymDir "PRESSURE_SWITCH_LOW.dwg"))
	  ((=  ID "PUSHBUTTON") (strcat SymDir "PUSHBUTTON.dwg"))
	  ((=  ID "PUSHBUTTON_NC") (strcat SymDir "PUSHBUTTON_NC.dwg"))
	  ((=  ID "SOLENOID_VALVE") (strcat SymDir "SOLENOID_VALVE.dwg"))
	  ((=  ID "TEMP_SWITCH_HIGH") (strcat SymDir "TEMP_SWITCH_HIGH.dwg"))
	  ((=  ID "TEMP_SWITCH_LOW") (strcat SymDir "TEMP_SWITCH_LOW.dwg"))
	  ((=  ID "TIME_DELAY_CLOSED") (strcat SymDir "TIME_DELAY_CLOSED.dwg"))
	  ((=  ID "TIME_DELAY_OPEN") (strcat SymDir "TIME_DELAY_OPEN.dwg"))
	  ((=  ID "AUX_RELAY") (strcat SymDir "AUX_RELAY.dwg"))
	  ((=  ID "CB") (strcat SymDir "CB.dwg"))
	  ((=  ID "CONTACT_NC") (strcat SymDir "CONTACT_NC.dwg"))
	  ((=  ID "CONTACT_NO") (strcat SymDir "CONTACT_NO.dwg"))
	  ((=  ID "DIFF_PRESSURE_SWITCH") (strcat SymDir "DIFF_PRESSURE_SWITCH.dwg"))
	  ((=  ID "FLOW_SWITCH") (strcat SymDir "FLOW_SWITCH.dwg"))
	  (t (strcat SymDir "CONTACT_NO.dwg"))
	  
       )
)

;-------------------------------------------------------------------------------
;DrawLine()                                                                     
;Standardizes drawling lines and makes it look cleaner in code                  
;Just a line command                                                            
;-------------------------------------------------------------------------------

(defun DrawLine(X1 Y1 X2 Y2)

	(command "._line"
		 (if (<= i 8)
	  		(strcat (itoa X1) "," (itoa(+ Y1 (* SCALEY (- 8 i)))) ",0") 		  ;Left Device Coords
	 		(strcat (itoa (+ X1 SCALEX)) "," (itoa(+ Y1 (* SCALEY (- 16 i)))) ",0") ;Right Device Coords
	         )
		 (if (<= i 8)
	  		(strcat (itoa X2) "," (itoa(+ Y2 (* SCALEY (- 8 i)))) ",0") 		  ;Left Device Coords
	 		(strcat (itoa (+ X2 SCALEX)) "," (itoa(+ Y2 (* SCALEY (- 16 i)))) ",0") ;Right Device Coords
	         )
		 ""
	)

)  

;-------------------------------------------------------------------------------
;GetFont()                                                                      
;Returns the font name given shorter accornym for cleanliness in code           
;-------------------------------------------------------------------------------
(defun GetFont(Size)

	(cond 	((= Size "S") "DWG_STYLE_SMALL")
		((= Size "M") "DWG_STYLE")
		((= Size "B") "DWG_STYLE_BOLD")
		((= Size "TITLE") "TITLE_SMALL")
		((= Size "TITLE_L") "TITLE_LARGE")
		(t "DWG_STYLE"))
  
)

;-------------------------------------------------------------------------------
;SetLayer()
;Sets the focus layer in order to draw 
;-------------------------------------------------------------------------------
(defun SetLayer(Layer)

	(command "_.layer" "s" Layer "")
  
)

;-------------------------------------------------------------------------------
;Clear()                                                                        
;Clears objects given DXF Selection - cleans up code                            
;-------------------------------------------------------------------------------
(defun Clear(Selection)
	(setq sel1 (ssget "x" Selection))
	(command "_.erase" sel1 "")
) 

;--------------------------------------------------------------------
;Everything below is code to access excel, not my code               
;--------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Program Name: GetExcel.lsp [GetExcel R6]
; Created By:   Terry Miller (Email: terrycadd@yahoo.com)
;               (URL: https://autolisp-exchange.com)
; Date Created: 9-20-03
; Function:     Several functions to get and put values into Excel cells.
;-------------------------------------------------------------------------------
; Revision History
; Rev  By     Date    Description
;-------------------------------------------------------------------------------
; 1    TM   9-20-03   Initial version
; 2    TM   8-20-07   Rewrote GetExcel.lsp and added several new sub-functions
;                     including ColumnRow, Alpha2Number and Number2Alpha written
;                     by Gilles Chanteau from Marseille, France.
; 3    TM   12-1-07   Added several sub-functions written by Gilles Chanteau
;                     including Cell-p, Row+n, and Column+n. Also added his
;                     revision of the PutCell function.
; 4    GC   9-20-08   Revised the GetExcel argument MaxRange$ to accept a nil
;                     and get the current region from cell A1.
; 5    TM   4-7-14    Revised error routine to work with script files.
; 6    TM   5-1-20    Revised GetExcel to be able to retrieve the data from a list
;                     of Sheet names and a list of Max ranges in one call to GetExcel.
;-------------------------------------------------------------------------------
; Overview of Main functions
;-------------------------------------------------------------------------------
; GetExcel - Stores the values from an Excel spreadsheet into *ExcelData@ list
;   Syntax:  (GetExcel ExcelFile$ SheetName$ MaxRange$)
;   Example 1: (GetExcel "C:\\Folder\\Filename.xls" "Sheet1" "L30")
;   Example 2: (GetExcel "C:\\Folder\\Filename.xls" (list "Sheet1" "Sheet2") (list "L30" "H747"))
; GetCell - Returns the cell value from the *ExcelData@ list
;   Syntax:  (GetCell Cell$)
;   Example: (GetCell "H15")
; Function example of usage:
; (defun c:Get-Example ()
;   (GetExcel "C:\\Folder\\Filename.xls" "Sheet1" "L30");<-- Edit Filename.xls
;   (GetCell "H21");Or you can just use the global *ExcelData@ list
; );defun
;-------------------------------------------------------------------------------
; OpenExcel - Opens an Excel spreadsheet
;   Syntax:  (OpenExcel ExcelFile$ SheetName$ Visible)
;   Example: (OpenExcel "C:\\Folder\\Filename.xls" "Sheet1" nil)
; PutCell - Put values into Excel cells
;   Syntax:  (PutCell StartCell$ Data$) or (PutCell StartCell$ DataList@)
;   Example: (PutCell "A1" (list "GP093" 58.5 17 "Base" "3'-6 1/4\""))
; CloseExcel - Closes Excel session
;   Syntax:  (CloseExcel ExcelFile$)
;   Example: (CloseExcel "C:\\Folder\\Filename.xls")
; Function example of usage:
; (defun c:Put-Example ()
;   (OpenExcel "C:\\Folder\\Filename.xls" "Sheet1" nil);<-- Edit Filename.xls
;   (PutCell "A1" (list "GP093" 58.5 17 "Base" "3'-6 1/4\""));Repeat as required
;   (CloseExcel "C:\\Folder\\Filename.xls");<-- Edit Filename.xls
;   (princ)
; );defun
;-------------------------------------------------------------------------------
; Note: Review the conditions of each argument in the function headings
;-------------------------------------------------------------------------------
; GetExcel - Stores the values from an Excel spreadsheet into *ExcelData@ list
; Arguments: 3
;   ExcelFile$ = Path and filename
;   SheetName$ = Sheet name or nil for not specified or a list of Sheet names like (list "Sheet1" "Sheet2" "Sheet3")
;   MaxRange$ = Maximum cell ID range to include or nil to get the current region from cell A1
;   or a list of Maximum cell ranges corresponding to the SheetNames list like (list "H40" "D72" "N237")
; Syntax examples:
; (GetExcel "C:\\Temp\\Temp.xls" "Sheet1" "E19") = Open C:\Temp\Temp.xls on Sheet1 and read up to cell E19
; (GetExcel "C:\\Temp\\Temp.xls" nil "XYZ123") = Open C:\Temp\Temp.xls on current sheet and read up to cell XYZ123
; (GetExcel "C:\\Temp\\Temp.xls" (list "Sheet1" "Sheet2" "Sheet3") (list "H40" "D72" "N237")) = Open Sheets in the
; SheetName list and read up to the corresponding Maximum cell range in the MaxRange list. To separate the data
; for each Sheet name use a method like: (setq Sheet1@ (nth 0 *ExcelData@)) (setq Sheet2@ (nth 1 *ExcelData@))
; and (setq Sheet3@ (nth 2 *ExcelData@)) per this example.
;-------------------------------------------------------------------------------
(defun GetExcel (ExcelFile$ SheetName$ MaxRange$ / Cnt# Column# ColumnRow@ CreateLists:
  CurRegion Data@ ExcelRange^ ExcelValue ExcelVariant^ Max_Range$ MaxColumn# MaxRow#
  Range$ Row# Sheet_Name$ Worksheet)
  ;-----------------------------------------------------------------------------
  ; CreateLists: - Creates Lists of SheetName$ up to MaxRange$ of Excel data
  ;-----------------------------------------------------------------------------
  (defun CreateLists: (Sheet_Name$ Max_Range$ / ReturnList@)
    (if Sheet_Name$
      (vlax-for Worksheet (vlax-get-property *ExcelApp% "Sheets")
        (if (= (vlax-get-property Worksheet "Name") Sheet_Name$)
          (vlax-invoke-method Worksheet "Activate")
        );if
      );vlax-for
    );if
    (if Max_Range$
      (progn
        (setq ColumnRow@ (ColumnRow Max_Range$))
        (setq MaxColumn# (nth 0 ColumnRow@))
        (setq MaxRow# (nth 1 ColumnRow@))
      );progn
      (progn
        (setq CurRegion (vlax-get-property (vlax-get-property
          (vlax-get-property *ExcelApp% "ActiveSheet") "Range" "A1") "CurrentRegion")
        );setq
        (setq MaxRow# (vlax-get-property (vlax-get-property CurRegion "Rows") "Count"))
        (setq MaxColumn# (vlax-get-property (vlax-get-property CurRegion "Columns") "Count"))
      );progn
    );if
    (setq Row# 1)
    (repeat MaxRow#
      (setq Data@ nil)
      (setq Column# 1)
      (repeat MaxColumn#
        (setq Range$ (strcat (Number2Alpha Column#)(itoa Row#)))
        (setq ExcelRange^ (vlax-get-property *ExcelApp% "Range" Range$))
        (setq ExcelVariant^ (vlax-get-property ExcelRange^ 'Value))
        (setq ExcelValue (vlax-variant-value ExcelVariant^))
        (setq ExcelValue
          (cond
            ((= (type ExcelValue) 'INT) (itoa ExcelValue))
            ((= (type ExcelValue) 'REAL) (rtosr ExcelValue))
            ((= (type ExcelValue) 'STR) (vl-string-trim " " ExcelValue))
            ((/= (type ExcelValue) 'STR) "")
          );cond
        );setq
        (setq Data@ (append Data@ (list ExcelValue)))
        (setq Column# (1+ Column#))
      );repeat
      (setq ReturnList@ (append ReturnList@ (list Data@)))
      (setq Row# (1+ Row#))
    );repeat
    ReturnList@
  );defun CreateLists:
  ;-----------------------------------------------------------------------------
  (if (= (type ExcelFile$) 'STR)
    (if (not (findfile ExcelFile$))
      (progn
        (alert (strcat "Excel file " ExcelFile$ " not found."))
        (exit)
      );progn
    );if
    (progn
      (alert "Excel file not specified.")
      (exit)
    );progn
  );if
  (gc)
  (if (setq *ExcelApp% (vlax-get-object "Excel.Application"))
    (progn
      (vlax-release-object *ExcelApp%)(gc)
    );progn
  );if
  (setq ExcelFile$ (findfile ExcelFile$))
  (setq *ExcelApp% (vlax-get-or-create-object "Excel.Application"))
  (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Open ExcelFile$)
  (setq *ExcelData@ nil)
  (if (= (type SheetName$) 'LIST)
    (progn
      (if (/= (type MaxRange$) 'LIST)
        (setq MaxRange$ (list MaxRange$))
      );if
      (setq Cnt# 0)
      (repeat (length SheetName$)
        (setq Sheet_Name$ (nth Cnt# SheetName$))
        (setq Max_Range$ (nth Cnt# MaxRange$))
        (princ (strcat "\nImporting " (vl-filename-base ExcelFile$) " - " Sheet_Name$ " data..."))(princ)
        (setq ReturnList@ (CreateLists: Sheet_Name$ Max_Range$))
        (setq *ExcelData@ (append *ExcelData@ (list ReturnList@)))
        (setq Cnt# (1+ Cnt#))
      );repeat
    );progn
    (progn
      (princ (strcat "\nImporting " (vl-filename-base ExcelFile$) " - " SheetName$ " data..."))(princ)
      (setq *ExcelData@ (CreateLists: SheetName$ MaxRange$))
    );progn
  );if
  (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") 'Close :vlax-False)
  (vlax-invoke-method *ExcelApp% 'Quit)
  (vlax-release-object *ExcelApp%)(gc)
  (setq *ExcelApp% nil)
  *ExcelData@
);defun GetExcel
;-------------------------------------------------------------------------------
; GetCell - Returns the cell value from the *ExcelData@ list
; Arguments: 1
;   Cell$ = Cell ID
; Syntax example: (GetCell "E19") = value of cell E19
;-------------------------------------------------------------------------------
(defun GetCell (Cell$ / Column# ColumnRow@ Return Row#)
  (setq ColumnRow@ (ColumnRow Cell$))
  (setq Column# (1- (nth 0 ColumnRow@)))
  (setq Row# (1- (nth 1 ColumnRow@)))
  (setq Return "")
  (if *ExcelData@
    (if (and (>= (length *ExcelData@) Row#)(>= (length (nth 0 *ExcelData@)) Column#))
      (setq Return (nth Column# (nth Row# *ExcelData@)))
    );if
  );if
  Return
);defun GetCell
;-------------------------------------------------------------------------------
; OpenExcel - Opens an Excel spreadsheet
; Arguments: 3
;   ExcelFile$ = Excel filename or nil for new spreadsheet
;   SheetName$ = Sheet name or nil for not specified
;   Visible = t for visible or nil for hidden
; Syntax examples:
; (OpenExcel "C:\\Temp\\Temp.xls" "Sheet2" t) = Opens C:\Temp\Temp.xls on Sheet2 as visible session
; (OpenExcel "C:\\Temp\\Temp.xls" nil nil) = Opens C:\Temp\Temp.xls on current sheet as hidden session
; (OpenExcel nil "Parts List" nil) =  Opens a new spreadsheet and creates a Part List sheet as hidden session
;-------------------------------------------------------------------------------
(defun OpenExcel (ExcelFile$ SheetName$ Visible / Sheet$ Sheets@ Worksheet)
  (if (= (type ExcelFile$) 'STR)
    (if (findfile ExcelFile$)
      (setq *ExcelFile$ ExcelFile$)
      (progn
        (alert (strcat "Excel file " ExcelFile$ " not found."))
        (exit)
      );progn
    );if
    (setq *ExcelFile$ "")
  );if
  (gc)
  (if (setq *ExcelApp% (vlax-get-object "Excel.Application"))
    (progn
      (vlax-release-object *ExcelApp%)(gc)
    );progn
  );if
  (setq *ExcelApp% (vlax-get-or-create-object "Excel.Application"))
  (if ExcelFile$
    (if (findfile ExcelFile$)
      (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Open ExcelFile$)
      (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Add)
    );if
    (vlax-invoke-method (vlax-get-property *ExcelApp% 'WorkBooks) 'Add)
  );if
  (if Visible
    (vla-put-visible *ExcelApp% :vlax-true)
  );if
  (if (= (type SheetName$) 'STR)
    (progn
      (vlax-for Sheet$ (vlax-get-property *ExcelApp% "Sheets")
        (setq Sheets@ (append Sheets@ (list (vlax-get-property Sheet$ "Name"))))
      );vlax-for
      (if (member SheetName$ Sheets@)
        (vlax-for Worksheet (vlax-get-property *ExcelApp% "Sheets")
          (if (= (vlax-get-property Worksheet "Name") SheetName$)
            (vlax-invoke-method Worksheet "Activate")
          );if
        );vlax-for
        (vlax-put-property (vlax-invoke-method (vlax-get-property *ExcelApp% "Sheets") "Add") "Name" SheetName$)
      );if
    );progn
  );if
  (princ)
);defun OpenExcel
;-------------------------------------------------------------------------------
; PutCell - Put values into Excel cells
; Arguments: 2
;   StartCell$ = Starting Cell ID
;   Data@ = Value or list of values
; Syntax examples:
; (PutCell "A1" "PART NUMBER") = Puts PART NUMBER in cell A1
; (PutCell "B3" '("Dim" 7.5 "9.75")) = Starting with cell B3 put Dim, 7.5, and 9.75 across
;-------------------------------------------------------------------------------
(defun PutCell (StartCell$ Data@ / Cell$ Column# ExcelRange Row#)
  (if (= (type Data@) 'STR)
    (setq Data@ (list Data@))
  )
  (setq ExcelRange (vlax-get-property *ExcelApp% "Cells"))
  (if (Cell-p StartCell$)
    (setq Column# (car (ColumnRow StartCell$))
          Row# (cadr (ColumnRow StartCell$))
    );setq
    (if (vl-catch-all-error-p
          (setq Cell$ (vl-catch-all-apply 'vlax-get-property
            (list (vlax-get-property *ExcelApp% "ActiveSheet") "Range" StartCell$))
          );setq
        );vl-catch-all-error-p
        (alert (strcat "The cell ID \"" StartCell$ "\" is invalid."))
        (setq Column# (vlax-get-property Cell$ "Column")
              Row# (vlax-get-property Cell$ "Row")
        );setq
    );if
  );if
  (if (and Column# Row#)
    (foreach Item Data@
      (vlax-put-property ExcelRange "Item" Row# Column# (vl-princ-to-string Item))
      (setq Column# (1+ Column#))
    );foreach
  );if
  (princ)
);defun PutCell
;-------------------------------------------------------------------------------
; CloseExcel - Closes Excel spreadsheet
; Arguments: 1
;   ExcelFile$ = Excel saveas filename or nil to close without saving
; Syntax examples:
; (CloseExcel "C:\\Temp\\Temp.xls") = Saveas C:\Temp\Temp.xls and close
; (CloseExcel nil) = Close without saving
;-------------------------------------------------------------------------------
(defun CloseExcel (ExcelFile$ / Saveas)
  (if ExcelFile$
    (if (= (strcase ExcelFile$) (strcase *ExcelFile$))
      (if (findfile ExcelFile$)
        (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") "Save")
        (setq Saveas t)
      );if
      (if (findfile ExcelFile$)
        (progn
          (vl-file-delete (findfile ExcelFile$))
          (setq Saveas t)
        );progn
        (setq Saveas t)
      );if
    );if
  );if
  (if Saveas
    (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook")
      "SaveAs" ExcelFile$ -4143 "" "" :vlax-false :vlax-false nil
    );vlax-invoke-method
  );if
  (vlax-invoke-method (vlax-get-property *ExcelApp% "ActiveWorkbook") 'Close :vlax-False)
  (vlax-invoke-method *ExcelApp% 'Quit)
  (vlax-release-object *ExcelApp%)(gc)
  (setq *ExcelApp% nil *ExcelFile$ nil)
  (princ)
);defun CloseExcel
;-------------------------------------------------------------------------------
; ColumnRow - Returns a list of the Column and Row number
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Cell$ = Cell ID
; Syntax example: (ColumnRow "ABC987") = '(731 987)
;-------------------------------------------------------------------------------
(defun ColumnRow (Cell$ / Column$ Char$ Row#)
  (setq Column$ "")
  (while (< 64 (ascii (setq Char$ (strcase (substr Cell$ 1 1)))) 91)
    (setq Column$ (strcat Column$ Char$)
          Cell$ (substr Cell$ 2)
    );setq
  );while
  (if (and (/= Column$ "") (numberp (setq Row# (read Cell$))))
    (list (Alpha2Number Column$) Row#)
    '(1 1);default to "A1" if there's a problem
  );if
);defun ColumnRow
;-------------------------------------------------------------------------------
; Alpha2Number - Converts Alpha string into Number
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Str$ = String to convert
; Syntax example: (Alpha2Number "ABC") = 731
;-------------------------------------------------------------------------------
(defun Alpha2Number (Str$ / Num#)
  (if (= 0 (setq Num# (strlen Str$)))
    0
    (+ (* (- (ascii (strcase (substr Str$ 1 1))) 64) (expt 26 (1- Num#)))
       (Alpha2Number (substr Str$ 2))
    );+
  );if
);defun Alpha2Number
;-------------------------------------------------------------------------------
; Number2Alpha - Converts Number into Alpha string
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Num# = Number to convert
; Syntax example: (Number2Alpha 731) = "ABC"
;-------------------------------------------------------------------------------
(defun Number2Alpha (Num# / Val#)
  (if (< Num# 27)
    (chr (+ 64 Num#))
    (if (= 0 (setq Val# (rem Num# 26)))
      (strcat (Number2Alpha (1- (/ Num# 26))) "Z")
      (strcat (Number2Alpha (/ Num# 26)) (chr (+ 64 Val#)))
    );if
  );if
);defun Number2Alpha
;-------------------------------------------------------------------------------
; Cell-p - Evaluates if the argument Cell$ is a valid cell ID
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 1
;   Cell$ = String of the cell ID to evaluate
; Syntax examples: (Cell-p "B12") = t, (Cell-p "BT") = nil
;-------------------------------------------------------------------------------
(defun Cell-p (Cell$)
  (and (= (type Cell$) 'STR)
    (or (= (strcase Cell$) "A1")
      (not (equal (ColumnRow Cell$) '(1 1)))
    );or
  );and
);defun Cell-p
;-------------------------------------------------------------------------------
; Row+n - Returns the cell ID located a number of rows from cell
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 2
;   Cell$ = Starting cell ID
;   Num# = Number of rows from cell
; Syntax examples: (Row+n "B12" 3) = "B15", (Row+n "B12" -3) = "B9"
;-------------------------------------------------------------------------------
(defun Row+n (Cell$ Num#)
  (setq Cell$ (ColumnRow Cell$))
  (strcat (Number2Alpha (car Cell$)) (itoa (max 1 (+ (cadr Cell$) Num#))))
);defun Row+n
;-------------------------------------------------------------------------------
; Column+n - Returns the cell ID located a number of columns from cell
; Function By: Gilles Chanteau from Marseille, France
; Arguments: 2
;   Cell$ = Starting cell ID
;   Num# = Number of columns from cell
; Syntax examples: (Column+n "B12" 3) = "E12", (Column+n "B12" -1) = "A12"
;-------------------------------------------------------------------------------
(defun Column+n (Cell$ Num#)
  (setq Cell$ (ColumnRow Cell$))
  (strcat (Number2Alpha (max 1 (+ (car Cell$) Num#))) (itoa (cadr Cell$)))
);defun Column+n
;-------------------------------------------------------------------------------
; rtosr - Used to change a real number into a short real number string
; stripping off all trailing 0's.
; Arguments: 1
;   RealNum~ = Real number to convert to a short string real number
; Returns: ShortReal$ the short string real number value of the real number.
;-------------------------------------------------------------------------------
(defun rtosr (RealNum~ / DimZin# ShortReal$)
  (setq DimZin# (getvar "DIMZIN"))
  (setvar "DIMZIN" 8)
  (setq ShortReal$ (rtos RealNum~ 2 8))
  (setvar "DIMZIN" DimZin#)
  ShortReal$
);defun rtosr

