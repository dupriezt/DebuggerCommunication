"
Sent by instances of SindarinDebuggerClient to instances of SindarinDebuggerServer to remotely send messages to the SindarinDebugger instance contained within the SeindarinDebuggerServer.
"
Class {
	#name : #SindarinRequest,
	#superclass : #NetworkRequest,
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
