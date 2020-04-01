Class {
	#name : #FailingTestForDebuggerCommunication,
	#superclass : #TestCase,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #tests }
FailingTestForDebuggerCommunication >> testFails [
	self assert: false
]
