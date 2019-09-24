"
Contains a SindarinDebugger. Listens on a port. Receives instances of SindarinRequest from a SindarinDebuggerClient and executes them on the SindarinDebugger it holds.
"
Class {
	#name : #SindarinDebuggerServer,
	#superclass : #Object,
	#traits : 'DebuggerServer',
	#classTraits : 'DebuggerServer classTrait',
	#instVars : [
		'sindarinDebugger'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerServer class >> newOnSindarinDebugger: aSindarinDebugger [
	^ self new newOnSindarinDebugger: aSindarinDebugger.
]

{ #category : #communication }
SindarinDebuggerServer class >> stopAll [
	self allInstancesDo: [ :inst | inst stop ].
]

{ #category : #'instance creation' }
SindarinDebuggerServer >> newOnSindarinDebugger: aSindarinDebugger [
	sindarinDebugger := aSindarinDebugger.
	^ self.
]

{ #category : #accessing }
SindarinDebuggerServer >> sindarinDebugger [
	^ sindarinDebugger
]
