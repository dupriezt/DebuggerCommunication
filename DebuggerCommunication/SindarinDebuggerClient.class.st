Class {
	#name : #SindarinDebuggerClient,
	#superclass : #Object,
	#category : #DebuggerCommunication
}

{ #category : #'private protocol' }
SindarinDebuggerClient >> send: aSymbol [
  ^self sendCommand: (SindarinCommand new command: aSymbol ; yourself)
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendCommand: aCommand [
	| client |
	client := ZnClient new.
	^ FLMaterializer materializeFromByteArray:  (client
		url: 'http://localhost:1234';
		entity: (ZnEntity bytes: aCommand serialized);
		post;
		response) entity bytes
]

{ #category : #'private protocol' }
SindarinDebuggerClient >> sendStepInCommand [
  ^self sendCommand: (SindarinCommand new command: #stepInto ; yourself)
]
