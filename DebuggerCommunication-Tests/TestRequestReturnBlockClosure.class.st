Class {
	#name : #TestRequestReturnBlockClosure,
	#superclass : #NetworkRequest,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #execution }
TestRequestReturnBlockClosure >> executeOn: aDebuggerServer [
	^ [ 42 ]
]

{ #category : #execution }
TestRequestReturnBlockClosure >> testMethod [
	self myMessage: 25
]
