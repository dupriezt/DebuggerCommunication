Class {
	#name : #SteppingCommand,
	#superclass : #Object,
	#instVars : [
		'command'
	],
	#category : #DebuggerCommunication
}

{ #category : #accessing }
SteppingCommand >> command: aString [ 
	command := aString.
]

{ #category : #accessing }
SteppingCommand >> executeOn: aDebuggerCommunication [ 
	^ command
]

{ #category : #accessing }
SteppingCommand >> serialized [
	^ FLSerializer serializeToByteArray: self.
]
