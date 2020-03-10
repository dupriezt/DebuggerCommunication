Class {
	#name : #TestRequestReturnContext,
	#superclass : #NetworkRequest,
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #execution }
TestRequestReturnContext >> executeOn: aDebuggerServer [
	^ aDebuggerServer sindarinDebugger context.
"	^ thisContext"
]
