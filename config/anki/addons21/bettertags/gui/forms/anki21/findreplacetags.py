# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'build/dist/designer/findreplacetags.ui'
#
# Created by: PyQt5 UI code generator 5.10.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(484, 320)
        self.verticalLayout = QtWidgets.QVBoxLayout(Dialog)
        self.verticalLayout.setObjectName("verticalLayout")
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 0, 1, 1)
        self.label_2 = QtWidgets.QLabel(Dialog)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 1, 0, 1, 1)
        self.regex = QtWidgets.QCheckBox(Dialog)
        self.regex.setObjectName("regex")
        self.gridLayout.addWidget(self.regex, 6, 1, 1, 1)
        self.ignoreCase = QtWidgets.QCheckBox(Dialog)
        self.ignoreCase.setChecked(False)
        self.ignoreCase.setObjectName("ignoreCase")
        self.gridLayout.addWidget(self.ignoreCase, 4, 1, 1, 1)
        self.limit = QtWidgets.QCheckBox(Dialog)
        self.limit.setObjectName("limit")
        self.gridLayout.addWidget(self.limit, 2, 1, 1, 1)
        self.wholeTags = QtWidgets.QCheckBox(Dialog)
        self.wholeTags.setChecked(False)
        self.wholeTags.setObjectName("wholeTags")
        self.gridLayout.addWidget(self.wholeTags, 3, 1, 1, 1)
        self.layoutFind = QtWidgets.QHBoxLayout()
        self.layoutFind.setObjectName("layoutFind")
        self.gridLayout.addLayout(self.layoutFind, 0, 1, 1, 1)
        self.layoutReplace = QtWidgets.QHBoxLayout()
        self.layoutReplace.setObjectName("layoutReplace")
        self.gridLayout.addLayout(self.layoutReplace, 1, 1, 1, 1)
        self.gridLayout.setColumnStretch(1, 1)
        self.verticalLayout.addLayout(self.gridLayout)
        self.perfWarning = QtWidgets.QLabel(Dialog)
        self.perfWarning.setWordWrap(True)
        self.perfWarning.setObjectName("perfWarning")
        self.verticalLayout.addWidget(self.perfWarning)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem)
        self.buttonBox = QtWidgets.QDialogButtonBox(Dialog)
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Help|QtWidgets.QDialogButtonBox.Ok|QtWidgets.QDialogButtonBox.RestoreDefaults)
        self.buttonBox.setObjectName("buttonBox")
        self.verticalLayout.addWidget(self.buttonBox)

        self.retranslateUi(Dialog)
        self.buttonBox.accepted.connect(Dialog.accept)
        self.buttonBox.rejected.connect(Dialog.reject)
        QtCore.QMetaObject.connectSlotsByName(Dialog)
        Dialog.setTabOrder(self.limit, self.wholeTags)
        Dialog.setTabOrder(self.wholeTags, self.ignoreCase)
        Dialog.setTabOrder(self.ignoreCase, self.regex)
        Dialog.setTabOrder(self.regex, self.buttonBox)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Find and Replace Tags"))
        self.label.setText(_translate("Dialog", "<b>Find</b>"))
        self.label_2.setText(_translate("Dialog", "<b>Replace With</b>:"))
        self.regex.setToolTip(_translate("Dialog", "Match and replace using Python-type regular expressions."))
        self.regex.setText(_translate("Dialog", "Treat input as &regular expression"))
        self.ignoreCase.setToolTip(_translate("Dialog", "Match tags regardless of their case. <br>This option has a major performance impact and should only be used when absolutely necessary."))
        self.ignoreCase.setText(_translate("Dialog", "&Ignore case"))
        self.limit.setToolTip(_translate("Dialog", "Only replace tags in the notes that are currently selected.<br>Disabling this option can have a major performance impact,<br>especially when combined with RegEx replacements."))
        self.limit.setText(_translate("Dialog", "&Limit to selected notes"))
        self.wholeTags.setToolTip(_translate("Dialog", "Only replace exact tag matches.<br>Disable this to perform sub-tag replacements."))
        self.wholeTags.setText(_translate("Dialog", "&Whole tags only"))
        self.perfWarning.setText(_translate("Dialog", "<b>Warning</b>: With the current option(s) and/or number of notes to walk through, the find and replace process might take a while to complete. Please do not close Anki while the add-on is working."))

