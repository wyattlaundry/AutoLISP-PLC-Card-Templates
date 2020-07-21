# AutoLISP-PLC-Card-Templates
This is a fully automated card drawing program that can be used to generate drawings based on IO data for PLC projects

## Pre-Requisites
- AutoCAD 2019-Present is required
  - Previous version are having difficulty connecting to Excel

## Input IO Data
In order for the templates to work properly, data is required in the specified IO List excel file. This data is to be formatted as plain text. 

- Open Excel file named "IO_List"
- Input IO data for each "type" of data (each has separate sheet)
  - **IO**
    - General IO Data for the card
  - **Power**
    - Data for basic power wiring for the card
  - **Title Block**
    - Title block data to for project information
- Save & Close 
  - Excel spreadsheet must be closed when running the template code

> Adding Columns/Rows/Fields will require changes to the template code

## Loading Application/Code
- Open desired card CAD drawing (.dwg)
- Load the MAIN.lsp template code
  - There are two options when loading the code for the CAD templates. You can manually load the code into the drawing each time, or enable auto-loading, which loads the MAIN code every time you open a new drawing.
    - **Manual**
      - Manage > Applications > Load Application > Select MAIN.lsp > Load
    - **Auto-Load**
      - Manage > Applications > Load Application > Startup Suite > Contents... > Select MAIN.lsp

> When prompted, select 'Always Load', else the template will not have the code to run properly.
  ### Loading Application Demo
  ![Recordit GIF](http://g.recordit.co/DmTh3sYKDx.gif)

## Interface

To launch the interface and use the GUI:

- Type 'TEMPLATE' in the command line
  - If this command is not recognized please follow the install process again
- Select desired drawing options
  - **Rack Number**
    - Select a rack number (Drop down value)
  - **Slot Number**
    - Select a slot number (Drop down value)
  - **Drawing Aspects** (Checklist)
    - Drawing
      - The IO Data of the drawing
    - Power
      - Power routing for the drawing
    - Title Block
      - Title block information for drawing
      
    ### GUI Demo
    ![Recordit GIF](http://g.recordit.co/EV9Tei3mdG.gif)

- Allow time for loading and rendering
  - AutoCAD first writes/reads from the IO_List excel file
  - AutoCAD then renders all objects that were selected in the GUI
  - **May take anywhere from 3-15 seconds**
  
  
## Other

### Adding New Templates

### Adding New Symbols (Device Symbols)
- Add new symbol as a drawing file to the 'Symbols' Folder
- Open 'Functions.lsp' in the Cards folder
  - Scroll down to the DetermineDevicePath function
  - Duplicate one of the lines found in the function
  - Change drawing name to match the one you put in the Symbols folder
- Add new symbol name to Excel (without .dwg extension)

### Render Time Improvment
If the render time is noticably slow, there are a few things that may help.
- Work locally by moving all files to your computer
  - Likely, the slow render time is consumed by the time it takes for the program to read/write to Excel over the network.

### File Path Modifications
The locations of all symbols, programs, and DCL files are required to be in their original location in order for the main program to access them. If you wish to change the location of any file with respect to the root folder you must:
- Open MAIN.lsp
- Change the file path variables
  - IO List (Excel) file path
  - Programs (LISP/DCL) file path
  - Symbols (DWG) file path
- File paths are relative to the location of the drawing you have opened.

