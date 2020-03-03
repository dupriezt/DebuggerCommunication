Class {
	#name : #TestRequestReturnFive,
	#superclass : #NetworkRequest,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #execution }
TestRequestReturnFive >> executeOn: aDebuggerServer [
	^ 5
]
