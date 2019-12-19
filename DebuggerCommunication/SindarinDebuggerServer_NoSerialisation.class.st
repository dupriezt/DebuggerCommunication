"
I am a copy of class SindarinDebuggerServer. This comment is copied from there, and might not be entirely accurate

Contains a SindarinDebugger. Listens on a port. Receives instances of SindarinRequest from a SindarinDebuggerClient and executes them on the SindarinDebugger it holds.
"
Class {
	#name : #'SindarinDebuggerServer_NoSerialisation',
	#superclass : #Object,
	#instVars : [
		'sindarinDebugger',
		'server'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerServer_NoSerialisation class >> newOnSindarinDebugger: aSindarinDebugger [
	^ self new newOnSindarinDebugger: aSindarinDebugger.
]

{ #category : #communication }
SindarinDebuggerServer_NoSerialisation class >> stopAll [
	self allInstancesDo: [ :inst | inst stop ].
]

{ #category : #'instance creation' }
SindarinDebuggerServer_NoSerialisation >> newOnSindarinDebugger: aSindarinDebugger [
	sindarinDebugger := aSindarinDebugger.
	^ self.
]

{ #category : #accessing }
SindarinDebuggerServer_NoSerialisation >> sindarinDebugger [
	^ sindarinDebugger
]

{ #category : #public }
SindarinDebuggerServer_NoSerialisation >> startListeningOnPort: anInt [
	server := ZnServer startOn: anInt.
	server onRequestRespond: [ :req |
		(req entity bytes asString asSymbol = #s) ifTrue: [ self sindarinDebugger step ].
		ZnResponse ok: #ok asByteArray. ].
]

{ #category : #public }
SindarinDebuggerServer_NoSerialisation >> stop [
	server stop.
]