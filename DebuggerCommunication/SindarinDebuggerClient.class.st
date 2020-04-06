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

{ #category : #'private protocol' }
SindarinDebuggerClient >> ping [
	| client serialisedCommand response request |
	client := ZnClient new.
	request := PingRequest new.
	serialisedCommand := (ZnEntity bytes: request serialized).
	response := client
		url: 'http://localhost:', port asString;
		entity: serialisedCommand;
		post;
		response.
	^ response entity contents = request correctResponse
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> resignalExceptionSignalledByRemoteDebugger: anObject [
	"@anObject is meant to be the materialised answer of the remotely debugged execution. If it is tjhe representation of an exception it signalled, we signal this exception in the client image so that debugging scripts can catch it"
	| exceptionToResignal |
	anObject isExceptionSignalledForDebuggedExecution ifTrue: [
		exceptionToResignal := (SmalltalkImage current classNamed: (anObject at: #exceptionClass)) new.
		anObject associationsDo: [ :assoc |
			(assoc key ~= #exceptionClass) ifTrue: [ exceptionToResignal instVarNamed: assoc key put: assoc value ].
		exceptionToResignal signal.
		]
	]
]

{ #category : #communication }
SindarinDebuggerClient >> send: aSymbol [
  ^self sendRequest: (SindarinRequest new command: aSymbol ; yourself)
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendRequest: aRequest [
	| client serialisedCommand response materialisedAnswer |
	client := ZnClient new.
	serialisedCommand := (ZnEntity bytes: aRequest serialized).
	response := client
		url: 'http://localhost:', port asString;
		entity: serialisedCommand;
		post;
		response.
	"self halt."
	materialisedAnswer := self materialise: response entity contents.
	self resignalExceptionSignalledByRemoteDebugger: materialisedAnswer.
	^ materialisedAnswer
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
