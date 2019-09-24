Class {
	#name : #SindarinDebuggerClient,
	#superclass : #Object,
	#instVars : [
		'port'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerClient class >> newOnPort: anInteger [
"example: anInteger = 1234"
	^ self new newOnPort: anInteger 
]

{ #category : #'instance creation' }
SindarinDebuggerClient >> newOnPort: anInteger [
	"Example: anInteger = 1234"
	port := anInteger.
	^ self
]

{ #category : #communication }
SindarinDebuggerClient >> send: aSymbol [
  ^self sendCommand: (SindarinRequest new command: aSymbol ; yourself)
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendCommand: aCommand [
	| client |
	client := ZnClient new.
	^ FLMaterializer materializeFromByteArray:  (client
		url: 'http://localhost:', port asString;
		entity: (ZnEntity bytes: aCommand serialized);
		post;
		response) entity bytes
]
