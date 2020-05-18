Class {
	#name : #EchoDebuggerDataEvent,
	#superclass : #Object,
	#instVars : [
		'index_working',
		'index_failing',
		'nodes_working',
		'nodes_failing'
	],
	#category : #DebuggerCommunication
}

{ #category : #accessing }
EchoDebuggerDataEvent >> index_failing [
	^ index_failing
]

{ #category : #accessing }
EchoDebuggerDataEvent >> index_failing: anObject [
	index_failing := anObject
]

{ #category : #accessing }
EchoDebuggerDataEvent >> index_working [
	^ index_working
]

{ #category : #accessing }
EchoDebuggerDataEvent >> index_working: anObject [
	index_working := anObject
]

{ #category : #'as yet unclassified' }
EchoDebuggerDataEvent >> nature [
	"Should return the name of the event as a string. Displayed in the UI"
	self subclassResponsibility
]

{ #category : #accessing }
EchoDebuggerDataEvent >> nodes_failing [
	nodes_failing ifNil: [ nodes_failing := OrderedCollection new ].
	^ nodes_failing
]

{ #category : #accessing }
EchoDebuggerDataEvent >> nodes_failing: anObject [
	nodes_failing := anObject
]

{ #category : #accessing }
EchoDebuggerDataEvent >> nodes_working [
	nodes_working ifNil: [ nodes_working := OrderedCollection new ].
	^ nodes_working
]

{ #category : #accessing }
EchoDebuggerDataEvent >> nodes_working: anObject [
	nodes_working := anObject
]

{ #category : #printing }
EchoDebuggerDataEvent >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	aStream nextPutAll: self index_working asString.
	aStream nextPutAll: ', '.
	aStream nextPutAll: self index_failing asString.
	aStream nextPutAll: ')'.
]
