from script import *
import sys
import os

FOLDER1 = "/../client1/conf/Sync"
FOLDER2 = "/../client2/conf/Sync"
PWD = os.getcwd()
FILE = "/"+str(sys.argv[1])#"/SampleVideo_1280x720_2mb.mp4"


def main():
    #print("test")
    clear()
    move_file(FILE, FOLDER1)
    clear()


if __name__=="__main__":
	main()


