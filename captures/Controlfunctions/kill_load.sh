#!/bin/bash           
                    
IFS=$OLDIFS
                                                                                                                                                                                                                                                            
#echo $pid_stress
#ps
sudo pstree "$pid_stress" -p -a -l > x; kill $(cut -d, -f2 x | cut -d' ' -f1)
rm x
#ps
