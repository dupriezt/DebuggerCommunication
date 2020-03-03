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

{ #category : #'private protocol' }
SindarinDebuggerClient >> materialise: aString [
	"(aString prefixMatchesRegex: 'Context*') ifTrue: [ ^ aString ]." "Ston can't create Context objects because they must be created with #newForMethod:"
	"(aString prefixMatchesRegex: '''Context''') ifTrue: [ ^ STON fromString: (aString allButFirst: ('''Context''' size)) ]." "We have a special serialisation for Contexts"
	"(aString prefixMatchesRegex: '''RBProgramNode''') ifTrue: [ ^ STON fromString: (aString allButFirst: ('''RBProgramNode''' size)) ]." "We have a special serialisation for RBProgramNode" 
	^ STON fromString: aString
]

{ #category : #'instance creation' }
SindarinDebuggerClient >> newOnPort: anInteger [
	"Example: anInteger = 1234"
	port := anInteger.
	^ self
]

{ #category : #communication }
SindarinDebuggerClient >> send: aSymbol [
  ^self sendRequest: (SindarinRequest new command: aSymbol ; yourself)
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendRequest: aRequest [
	| client serialisedCommand response |
	client := ZnClient new.
	serialisedCommand := (ZnEntity bytes: aRequest serialized).
	response := client
		url: 'http://localhost:', port asString;
		entity: serialisedCommand;
		post;
		response.
	"self halt."
	^ self materialise: response entity contents
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendRequest_materialisation: aRequest [
	| client |
	client := ZnClient new.
	^ FLMaterializer materializeFromByteArray:  (client
		url: 'http://localhost:', port asString;
		entity: (ZnEntity bytes: aRequest serialized);
		post;
		response) entity bytes
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendRequest_noMaterialisation: aRequest [
	| client |
	client := ZnClient new.
	^  (client
		url: 'http://localhost:', port asString;
		entity: (ZnEntity bytes: aRequest serialized);
		post;
		response) entity bytes
]

{ #category : #communication }
SindarinDebuggerClient >> send_noMaterialisation: aSymbol [
  ^self sendRequest_noMaterialisation: (SindarinRequest new command: aSymbol ; yourself)
]
