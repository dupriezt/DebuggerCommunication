Class {
	#name : #TestExecution,
	#superclass : #TestCase,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #accessing }
TestExecution >> method1 [
	self method2.
	^ self method3.
]

{ #category : #accessing }
TestExecution >> method2 [
	^42 + 42
]

{ #category : #accessing }
TestExecution >> method3 [
	self halt.
	^ Point new
]

{ #category : #accessing }
TestExecution >> start [
	^ self method1.
]

{ #category : #accessing }
TestExecution >> testStart [
	^ self method1.
]
