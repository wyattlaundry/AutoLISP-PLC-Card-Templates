# AutoLISP-PLC-Card-Templates
This is a fully automated card drawing program that can be used to generate drawings based on IO data for PLC projects

## Input IO Data
In order for the templates to work properly, data is required in the specified IO List excel file. This data is to be formatted as plain text. 

- Open Excel file named "IO_List"
- Input IO data for each "type" of data (each has separate sheet)
  - IO
    - General IO Data for the card
  - Power
    - Data for basic power wiring for the card
  - Title Block
    - Title block data to for project information
- Save & Close 
  - Excel spreadsheet must be closed when running the template code

> Adding Columns/Rows/Fields will require changes to the template code

## Loading Template/Code
- Open desired card CAD drawing (.dwg)
- Load the MAIN.lsp template code
  - There are two options when loading the code for the CAD templates. You can manually load the code into the drawing each time, or enable auto-loading, which loads the MAIN code every time you open a new drawing.
    - Manual 
      - Manage > Applications > Load Application > Select MAIN.lsp > Load
    - Auto-Load
      - Manage > Applications > Load Application > Startup Suite > Contents... > Select MAIN.lsp

> When prompted, select 'Always Load', else the template will not have the code to run properly.

## Interface

To launch the interface and use the GUI:

- Type 'TEMPLATE' in the command line
  - If this command is not recognized please follow the install process again
- Select desired drawing options
  - Rack Number
    - Select a rack number (Drop down value)
  - Slot Number
    - Select a slot number (Drop down value)
  - Drawing Aspects (Checklist)
    - Drawing
      - The IO Data of the drawing
    - Power
      - Power routing for the drawing
    - Title Block
      - Title block information for drawing
      
![Recordit GIF](http://g.recordit.co/EV9Tei3mdG.gif)

- Allow time for loading and rendering
  - AutoCAD first writes/reads from the IO_List excel file
  - AutoCAD then renders all objects that were selected in the GUI
  - May take anywhere from 3-15 seconds
