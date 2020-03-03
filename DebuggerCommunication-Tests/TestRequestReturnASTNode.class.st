Class {
	#name : #TestRequestReturnASTNode,
	#superclass : #NetworkRequest,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #execution }
TestRequestReturnASTNode >> executeOn: aDebuggerServer [
	^ (self class >> #testMethod) ast body children first
]

{ #category : #execution }
TestRequestReturnASTNode >> testMethod [
	self myMessage: 25
]
