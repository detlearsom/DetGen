# Prototype GUI for running captures

This directory contains a GUI for running captures, it's no longer maintained.

## Generating traffic 

1. `cd` into the DetGen directory
2. Run `sudo ./GUI/GUI.sh`
3. In the dialogue field, select the particular traffic scenario, either benign or attack, 
   for which you want to generate traffic 

![Example dialogue window to select benign scenarios](old/img/Dialogue1.png)

4. Select the particular activity as well as the corresponding parameters for file-size, caching, congestion etc. You can also choose to randomise them.

![Example dialogue window to select transfer file parameters](old/img/Dialogue2.png)
  |  ![Example dialogue window to select congestion parameters](old/img/Dialogue3.png)


5. Select how many repetitions you want to run.
6. Once done, find your generated traffic in the directory Generated_data


