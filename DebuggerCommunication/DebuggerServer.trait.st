Trait {
	#name : #DebuggerServer,
	#instVars : [
		'server'
	],
	#category : #DebuggerCommunication
}

{ #category : #public }
DebuggerServer >> handleRequest: req [
	| command |
	command := FLMaterializer materializeFromByteArray: req.
	^ command executeOn: self.
]

{ #category : #public }
DebuggerServer >> startListeningOnPort: anInt [
	server := ZnServer startOn: anInt.
	server onRequestRespond: [ :req |
		ZnResponse ok: ( ZnByteArrayEntity bytes: ( FLSerializer serializeToByteArray: ( self handleRequest: req entity bytes))). ].
]

{ #category : #public }
DebuggerServer >> stop [
	server stop.
]
