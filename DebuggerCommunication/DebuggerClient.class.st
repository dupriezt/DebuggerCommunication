Class {
	#name : #DebuggerClient,
	#superclass : #Object,
	#category : #DebuggerCommunication
}

{ #category : #'private protocol' }
DebuggerClient >> sendCommand: aCommand [
	| client |
	client := ZnClient new.
	^ FLMaterializer materializeFromByteArray:  (client
		url: 'http://localhost:1234';
		entity: (ZnEntity bytes: aCommand serialized);
		post;
		response) entity bytes
]

{ #category : #'private protocol' }
DebuggerClient >> sendStepInCommand [
  ^self sendCommand: (SteppingCommand new command: #stepInto ; yourself)
]
