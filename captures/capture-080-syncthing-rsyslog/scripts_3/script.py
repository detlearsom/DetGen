
import os
import shutil
import fileinput
from time import sleep

FOLDER1 = "/../client1/conf/Sync"
FOLDER2 = "/../client2/conf/Sync"
FOLDER3 = "/../client3/conf/Sync"
DATADIR = "/../dataToShare"
TEST_STRING = "This is a test string to verify that sharing works."
PWD = os.getcwd()
FILE1 = ('test.txt')
FILE2 = ('test2.txt')
STRING2 = "This is a second string."
STRING3 = "Even more exciting."

def clear():
    DIR = PWD+FOLDER1
    for the_file in os.listdir(DIR):
        file_path = os.path.join(DIR, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
        except Exception as e:
            print(e)

    DIR=PWD+FOLDER2
    for the_file in os.listdir(DIR):
        file_path = os.path.join(DIR, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
        except Exception as e:
            print(e)
    
    DIR=PWD+FOLDER3
    for the_file in os.listdir(DIR):
        file_path = os.path.join(DIR, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
        except Exception as e:
            print(e)


	
def delete_file(filename, folder):
	os.chdir(PWD + folder)
	if os.path.exists(filename):
		os.remove(filename)
	else:
		print("The file does not exist")
		return

	check_change(filename, "", folder)
	

def replace_text(filename, folder, textToReplace, textToRemove):
	os.chdir(PWD+folder)
	if not os.path.exists(filename): 
		print("The file does not exist.")
		return

	f = open(filename, 'r')
	text = f.read()
	f.close()
	newText = text.replace(textToRemove, textToReplace)
	f = open(filename, 'w')
	f.write(newText)
	f.close()
	
	check_change(filename, newText, folder)


def add_text(filename, filetext, folder):
	os.chdir(PWD+folder)
	f = open(filename,'w+')
	f.write(filetext)
	f.close()

	check_change(filename, filetext, folder)


def move_file(filename, folder):
    shutil.copy2(PWD + DATADIR+filename, PWD+folder)
    TIMEOUT=70
    x1=0
    x2=0
    x3=0
    for i in range(TIMEOUT):
        sleep(1)
        if folder==FOLDER1:
            if os.path.exists(PWD+FOLDER2+filename)&x2==0:
                print("Big file transferred successfully to client 2.")
                x2=1
            if os.path.exists(PWD+FOLDER3+filename)&x3==0:
                print("Big file transferred successfully to client 3.")
                x3=1
            if x2==1&x3==1:
                return
        elif folder==FOLDER2:
            if os.path.exists(PWD+FOLDER1+filename)&x1==0:
                print ("Big file transferred successfully to client 1.")
                x1=1
            if os.path.exists(PWD+FOLDER3+filename)&x3==0: 
                print ("Big file transferred successfully to client 3.")
                x3=1
            if x1==1&x3==1:
                return
        else:
            if os.path.exists(PWD+FOLDER1+filename)&x1==0: 
                print ("Big file transferred successfully to client 1.")
                x1=1
            if os.path.exists(PWD+FOLDER2+filename)&x2==0: 
                print ("Big file transferred successfully to client 2.")
                x2=1
            if x1==1&x2==1:
                return
    print("Big file transfer unsuccessful.")

def check_change(filename, textCheck, initialFolder):
	TIMEOUT=70
	success=0
	folders = [FOLDER1, FOLDER2, FOLDER3]
	text = ""
	for i in range(TIMEOUT):
		sleep(1)
		for folder in folders:
			if folder==initialFolder: continue
			os.chdir(PWD + folder)
			try:
				f2 = open(filename,'r')
				text = f2.read()
				if textCheck==text:
					print("File transferred successfully to client " + folder[10])
					success = success + 1
					if success==2: return
			except FileNotFoundError:
				if textCheck=='': 
					print("File deleted successfully from client " + folder[10])
					success = success + 1
					if success==2: return
				elif i==TIMEOUT-1: print ("File not transferred.")
	
	print("Oops. Something went wrong in client " + folder[10] + ". Output: " + text)

