from script import *
import random as rd
import math as mt
import string as st

pi=mt.atan(1)*4

RN=rd.uniform(0,1)
RN2=mt.ceil(10000*(mt.sin((0.5*RN)*pi)/mt.cos((0.5*RN)*pi)))
TEST_STRING = ''.join(rd.choices(st.ascii_uppercase + st.digits, k=RN2))

RN=rd.uniform(0,1)
RN2=mt.ceil(10000*(mt.sin((0.5*RN)*pi)/mt.cos((0.5*RN)*pi)))
STRING2 = ''.join(rd.choices(st.ascii_uppercase + st.digits, k=RN2))
#STRING2 = "This is a second string."

RN=rd.uniform(0,1)
RN2=mt.ceil(10000*(mt.sin((0.5*RN)*pi)/mt.cos((0.5*RN)*pi)))
STRING3 = ''.join(rd.choices(st.ascii_uppercase + st.digits, k=RN2))
#STRING3 = "Even more exciting."

FILE1 = (''.join(rd.choices(st.ascii_uppercase + st.digits, k=10))+'.txt')
FILE2 = (''.join(rd.choices(st.ascii_uppercase + st.digits, k=10))+'.txt')

FOLDER1 = "/../client1/conf/Sync"
FOLDER2 = "/../client2/conf/Sync"
FOLDER3 = "/../client3/conf/Sync"
PWD = os.getcwd()

def main():
	clear()
	add_text(FILE1, TEST_STRING, FOLDER1)
	replace_text(FILE1, FOLDER3, STRING2, TEST_STRING)

if __name__=="__main__":
	main()

