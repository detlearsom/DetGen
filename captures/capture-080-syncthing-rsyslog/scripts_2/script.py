
import os
import shutil
import fileinput
from time import sleep

FOLDER1 = "/../client1/conf/Sync"
FOLDER2 = "/../client2/conf/Sync"
TEST_STRING = "This is a test string to verify that sharing works."
PWD = os.getcwd()
FILE1 = ('test.txt')
FILE2 = ('test2.txt')
STRING2 = "This is a second string."
STRING3 = "Even more exciting."

#def main():
#	add_text(FILE1, TEST_STRING, FOLDER1
#	replace_text(FILE1, FOLDER2, STRING2, TEST_STRING)
#	add_text(FILE2, STRING3, FOLDER2)
#	delete_file(FILE1, FOLDER1)

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
	shutil.copy2(PWD+"/../dataToShare" +filename, PWD+folder)
	TIMEOUT = 70
	for i in range(TIMEOUT):
		sleep(1)
		if folder==FOLDER1:
			if os.path.exists(PWD+FOLDER2+filename): 
				print("Big file transferred successfully.")
				return
		else:
			if os.path.exists(PWD+FOLDER1+filename): 
				print ("Big file transferred successfully.")
				return
	
	print ("Big file transfer failed")

def check_change(filename, textCheck, folder):
	TIMEOUT=70
	for i in range(TIMEOUT):
		sleep(1)
		if folder==FOLDER1: os.chdir(PWD + FOLDER2)
		else: os.chdir (PWD + FOLDER1)
		try:
			f2 = open(filename,'r')
			text = f2.read()
			if textCheck==text:
				print("File transferred successfully.")
				return
		except FileNotFoundError:
			if textCheck=='': 
				print("File deleted successfully.")
				return
			elif i==TIMEOUT-1:
				print ("File not transferred.")
				return
			else:
				pass

	print("Oops. Something went wrong. Output: " + text)




#if __name__=="__main__":
#	main()

