"
Encapsulates a SindarinDebuggerClient. Serves as a proxy to the SindarinDebuggerServer this client is sending requests to.
"
Class {
	#name : #SindarinDebuggerProxyClient,
	#superclass : #Object,
	#instVars : [
		'sindarinDebuggerClient'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerProxyClient class >> newOnSindarinDebuggerClient: aSindarinDebuggerClient [
	^ self new newOnSindarinDebuggerClient: aSindarinDebuggerClient.
]

{ #category : #'reflective operations' }
SindarinDebuggerProxyClient >> doesNotUnderstand: aMessage [
	aMessage arguments isNotEmpty ifTrue: [ self error: 'Does not support messages with arguments yet' ].
	^ sindarinDebuggerClient send: aMessage selector.
]

{ #category : #'instance creation' }
SindarinDebuggerProxyClient >> newOnSindarinDebuggerClient: aSindarinDebuggerClient [
	sindarinDebuggerClient := aSindarinDebuggerClient.
	^ self
]

{ #category : #'Sindarin API' }
SindarinDebuggerProxyClient >> node [
	^ sindarinDebuggerClient send: #node.
]

{ #category : #'Sindarin API' }
SindarinDebuggerProxyClient >> step [
	^ sindarinDebuggerClient send: #step.
]
