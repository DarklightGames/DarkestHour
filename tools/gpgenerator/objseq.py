# UI
from Tkinter import *

# Variables
f = open('objseq_input.txt', 'r')

#print f.read()


class Objective(object):
    #grouped_obj		# List of obj_num that are grouped with this objective
    #allies_adv_obj		# List of obj_num that are to be unlocked when allies capture this objective
    #axis_adv_obj		# List of obj_num that are to be unlocked when axis capture this objective
    def __init__(self, num):
        self.obj_num = num
    def __repr__(self):
        return "ObjNum=" + str(self.obj_num)
    def other_method(self):
        pass # do something else


root = Tk()

leftFrame = Frame(root)
leftFrame.pack(side=LEFT)

topFrame = Frame(root)
topFrame.pack()

bottomFrame = Frame(root)
bottomFrame.pack(side=BOTTOM)

button1 = Button(topFrame, text="Button 1", fg="black")
button2 = Button(topFrame, text="Button 2", fg="black")
button3 = Button(topFrame, text="Button 3", fg="black")

button4 = Button(bottomFrame, text="Button 4", fg="white")

button5 = Button(leftFrame, text="Button 5", fg="green")

button1.pack(side=LEFT)
button2.pack(side=LEFT)
button3.pack(side=LEFT)
button4.pack()
button5.pack()

Objective_List = [Objective(0), Objective(1)]

Batman = Objective(1)

#print Batman

firstLabel = Label(root, text=Batman)
firstLabel.pack()

secondLabel = Label(root, text=f.read())
secondLabel.pack()

root.mainloop()





#print Objective_List

#for i in range (0, 10):
#	print i


"""
#I need a function that will generate a list of objects (objectives) and assign them ObjNums = the index of the list
"""
#EOF
