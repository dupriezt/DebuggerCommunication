Class {
	#name : #'SindarinDebuggerProxyClient_NoMaterialisation',
	#superclass : #Object,
	#instVars : [
		'sindarinDebuggerClient'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerProxyClient_NoMaterialisation class >> newOnSindarinDebuggerClient: aSindarinDebuggerClient [
	^ self new newOnSindarinDebuggerClient: aSindarinDebuggerClient.
]

{ #category : #'reflective operations' }
SindarinDebuggerProxyClient_NoMaterialisation >> doesNotUnderstand: aMessage [
	aMessage arguments isNotEmpty ifTrue: [ self error: 'Does not support messages with arguments yet' ].
	^ sindarinDebuggerClient send_noMaterialisation: aMessage selector.
]

{ #category : #'instance creation' }
SindarinDebuggerProxyClient_NoMaterialisation >> newOnSindarinDebuggerClient: aSindarinDebuggerClient [
	sindarinDebuggerClient := aSindarinDebuggerClient.
	^ self
]
