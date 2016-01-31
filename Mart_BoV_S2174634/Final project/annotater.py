#!usr/bin/python3.4

import sys
from PyQt4 import QtGui, QtCore
from collections import defaultdict


class BoxDrawer(QtGui.QGraphicsPixmapItem):
	""" Draws rectangular boxes on the images """
	def __init__(self, pixmap = None, parent = None, scene = None):
		super(BoxDrawer, self).__init__()
		self.parent = parent
		self.startX, self.startY = -1, -1
		self.radius = 1
		self.rectList = []
		self.coordList = []

		self.pen = QtGui.QPen(QtCore.Qt.SolidLine)
		self.pen.setColor(QtCore.Qt.blue)
		self.pen.setWidth(3)

		self.brush = QtGui.QBrush(QtCore.Qt.blue)
	
	def paint(self, painter, option, widget = None):
		try:
			painter.drawPixmap(0, 30, self.pixmap())
			painter.setPen(self.pen)
			width = self.endX - self.startX
			height = self.endY - self.startY
			self.rectList.append([self.startX, self.startY, width, height])
			for corners in self.rectList:
				rect = painter.drawRect(corners[0], corners[1], corners[2], corners[3])
		except AttributeError:
			pass

	def mousePressEvent(self, event):
		self.startX=event.pos().x()
		self.startY=event.pos().y()
		print("Top left corner at X:{} Y:{}".format(self.startX,self.startY))
		#ImgAnnotaterGUI.addToDict(self,self.x,self.y)


	def mouseReleaseEvent(self, event):
		self.endX=event.pos().x()
		self.endY=event.pos().y()
		print("Bottom right corner at X:{} Y:{}".format(self.endX, self.endY))
		self.coordList.append((self.startX, self.startY, self.endX, self.endY))
		self.update()
		#self.returnCoords()

	def returnCoords(self):
		print(self.symbollength)

class ImgAnnotaterGUI(QtGui.QWidget):
	""" Graphical interface for the image annotater """
	def __init__(self):
		super(ImgAnnotaterGUI, self).__init__()
		self.initUI()

	def initUI(self):
		""" Initializes the GUI """
		self.grid = QtGui.QGridLayout()
		self.grid.setSpacing(5)
		
		self.instruction = QtGui.QLabel(self)
		self.instructiontext = 'Welcome to the image annotater!\nIn this program you can annotate images with boxes based on predefined non-logical symbols. The images used for this program need to be in the .png format.\nAfter opening an image, the corrosponding model (which has to be in the same folder as the image) will be loaded as well.\nThe non-logical symbols from which you can choose will be shown in the list on the left. Because of technical problems, no distinction can be made between symbols.\nTo draw the rectangles on simply drag from the left upper corner to right bottom corner.'
		self.instruction.setText(self.instructiontext)

		self.filename = self.imageOpener()
		self.imagefile = QtGui.QPixmap(self.filename)
		
		# Attempt to make it possible to select a symbol and assign a rectangle to it, but seemed to draw random rectangles
		"""
		self.symbolslist = QtGui.QListWidget(self)
		self.modelOpener()
		for symbol in self.symbolList:
			self.symbolslist.addItem(symbol)"""
		
		self.symbolslist = QtGui.QTextEdit(self)
		self.modelOpener()
		for symbol in self.symbolList:
			self.symbolslist.append(symbol)
		self.symbolslist.setReadOnly(True)

		self.filelabel = QtGui.QLabel(self)
		self.filelabel.setText("Model: " + self.modelname.split('/')[-1])
		
		self.graphscene = QtGui.QGraphicsScene()
		self.imagelabel = BoxDrawer(scene = self.graphscene, parent = self)
		self.graphscene.addItem(self.imagelabel)
		self.graphview = QtGui.QGraphicsView(self.graphscene)
		self.imagelabel.setPixmap(self.imagefile)

		self.grid.addWidget(self.symbolslist, 1, 0, 5, 1)
		self.grid.addWidget(self.filelabel, 1, 1, 1, 3)
		self.grid.addWidget(self.instruction, 2, 1, 1, 3)
		self.grid.addWidget(self.graphview, 3, 1)
		
		self.setGeometry(300, 300, 900, 650)
		self.setWindowTitle('Image Annotater')
		self.setLayout(self.grid)
		self.show()
		

	def imageOpener(self):
		""" Opens a filewindow to select the image """
		fname = QtGui.QFileDialog.getOpenFileName(self, 'Open image file', '.')
		if fname != '':
			return fname

	def modelOpener(self):
		""" Opens the model corresponding to the image opened """
		self.modelname = str(self.filename.split('.')[0]) + '.mod'
		modelfile = open(self.modelname, 'r')
		lines = [line.strip() for line in modelfile]
		self.symbolList = []
		for line in lines:
			if line.startswith('[f(1,n'):
				splitline = line[1:].split('_')[1:-1]
				if len(splitline) == 1:
					self.symbolList.append(line[1:].split('_')[1:-1][0])
				else:
					self.symbolList.append('_'.join(line[1:].split('_')[1:-1]))
			if line.startswith('f(1,n'):
				splitline = line.split('_')[1:-1]
				if len(splitline) == 1:
					self.symbolList.append(line.split('_')[1:-1][0])
				else:
					self.symbolList.append('_'.join(line.split('_')[1:-1]))
		self.symbolListlength = len(self.symbolList)


	def addToDict(self,x,y):
		""" Prints coordinates from the corners """
		print(x,y)

	def giveLength(self):
		return self.symbolListlength
		


if __name__ == '__main__':
	app = QtGui.QApplication(sys.argv)
	i = ImgAnnotaterGUI()
	i.show()
	app.exec_()