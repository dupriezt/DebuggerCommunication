Class {
	#name : #FodderForDebuggerCommunicationTest,
	#superclass : #TestCase,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #tests }
FodderForDebuggerCommunicationTest >> testFails [
	self assert: false
]

{ #category : #tests }
FodderForDebuggerCommunicationTest >> testPasses [
	self assert: true
]
