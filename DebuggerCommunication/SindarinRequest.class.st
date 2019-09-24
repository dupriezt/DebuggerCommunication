"
Sent by instances of SindarinDebuggerClient to instances of SindarinDebuggerServer to remotely send messages to the SindarinDebugger instance contained within the SeindarinDebuggerServer.
"
Class {
	#name : #SindarinRequest,
	#superclass : #Object,
	#instVars : [
		'command'
	],
	#category : #DebuggerCommunication
}

{ #category : #accessing }
SindarinRequest >> command: aSymbol [ 
	command := aSymbol.
]

{ #category : #accessing }
SindarinRequest >> executeOn: aDebuggerServer [
	^ aDebuggerServer sindarinDebugger perform: command
]

{ #category : #accessing }
SindarinRequest >> serialized [
	^ FLSerializer serializeToByteArray: self.
]
