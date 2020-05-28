# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'designer/import_dialog.ui'
#
# Created by: PyQt5 UI code generator 5.5.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(450, 500)
        Dialog.setSizeGripEnabled(True)
        self.verticalLayout = QtWidgets.QVBoxLayout(Dialog)
        self.verticalLayout.setObjectName("verticalLayout")
        self.formLayout = QtWidgets.QFormLayout()
        self.formLayout.setObjectName("formLayout")
        self.deckChooser = QtWidgets.QWidget(Dialog)
        self.deckChooser.setObjectName("deckChooser")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.SpanningRole, self.deckChooser)
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setObjectName("label")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label)
        self.titleBox = QtWidgets.QLineEdit(Dialog)
        self.titleBox.setObjectName("titleBox")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.titleBox)
        self.label_3 = QtWidgets.QLabel(Dialog)
        self.label_3.setObjectName("label_3")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.LabelRole, self.label_3)
        self.tagsBox = QtWidgets.QLineEdit(Dialog)
        self.tagsBox.setObjectName("tagsBox")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.FieldRole, self.tagsBox)
        self.label_2 = QtWidgets.QLabel(Dialog)
        self.label_2.setObjectName("label_2")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.LabelRole, self.label_2)
        self.contextLinesSpin = QtWidgets.QSpinBox(Dialog)
        self.contextLinesSpin.setMinimum(1)
        self.contextLinesSpin.setMaximum(20)
        self.contextLinesSpin.setProperty("value", 2)
        self.contextLinesSpin.setObjectName("contextLinesSpin")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.FieldRole, self.contextLinesSpin)
        self.verticalLayout.addLayout(self.formLayout)
        self.textBox = QtWidgets.QPlainTextEdit(Dialog)
        self.textBox.setObjectName("textBox")
        self.verticalLayout.addWidget(self.textBox)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.openFileButton = QtWidgets.QPushButton(Dialog)
        self.openFileButton.setAutoDefault(False)
        self.openFileButton.setDefault(False)
        self.openFileButton.setObjectName("openFileButton")
        self.horizontalLayout.addWidget(self.openFileButton)
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.addCardsButton = QtWidgets.QPushButton(Dialog)
        self.addCardsButton.setAutoDefault(False)
        self.addCardsButton.setDefault(True)
        self.addCardsButton.setFlat(False)
        self.addCardsButton.setObjectName("addCardsButton")
        self.horizontalLayout.addWidget(self.addCardsButton)
        self.cancelButton = QtWidgets.QPushButton(Dialog)
        self.cancelButton.setAutoDefault(False)
        self.cancelButton.setObjectName("cancelButton")
        self.horizontalLayout.addWidget(self.cancelButton)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.label.setBuddy(self.titleBox)
        self.label_3.setBuddy(self.tagsBox)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "LPCG – Import Lyrics/Poetry"))
        self.label.setText(_translate("Dialog", "&Title"))
        self.label_3.setText(_translate("Dialog", "Ta&gs"))
        self.label_2.setText(_translate("Dialog", "Lines of Context"))
        self.openFileButton.setToolTip(_translate("Dialog", "Replace the contents of the poem editor with a text file on your computer."))
        self.openFileButton.setText(_translate("Dialog", "&Open file"))
        self.addCardsButton.setToolTip(_translate("Dialog", "Generate notes from the text in the poem editor."))
        self.addCardsButton.setText(_translate("Dialog", "&Add notes"))
        self.cancelButton.setText(_translate("Dialog", "&Cancel"))

