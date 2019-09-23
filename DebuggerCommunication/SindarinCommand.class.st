Class {
	#name : #SindarinCommand,
	#superclass : #Object,
	#instVars : [
		'command'
	],
	#category : #DebuggerCommunication
}

{ #category : #accessing }
SindarinCommand >> command: aSymbol [ 
	command := aSymbol.
]

{ #category : #accessing }
SindarinCommand >> executeOn: aDebuggerServer [
	^ aDebuggerServer sindarinDebugger perform: command
]

{ #category : #accessing }
SindarinCommand >> serialized [
	^ FLSerializer serializeToByteArray: self.
]
