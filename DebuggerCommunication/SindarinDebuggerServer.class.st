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

{ #category : #'instance creation' }
SindarinDebuggerServer >> newOnSindarinDebugger: aSindarinDebugger [
	sindarinDebugger := aSindarinDebugger.
	^ self.
]

{ #category : #accessing }
SindarinDebuggerServer >> sindarinDebugger [
	^ sindarinDebugger
]
