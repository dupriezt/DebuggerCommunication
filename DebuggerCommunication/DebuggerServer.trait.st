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
	| result serialisation |
	server := ZnServer startOn: anInt.
	server
		onRequestRespond: [ :req | 
			result := [ self handleRequest: req entity bytes ]
				on: Error
				do: [ :e | self halt: 'result' ].
			serialisation := [ FLSerializer serializeToByteArray: result ]
				on: Error
				do: [ :e | self halt: 'serialisation' ].
			ZnResponse ok: (ZnStringEntity text: 'ok') ]
]

{ #category : #public }
DebuggerServer >> stop [
	server stop.
]
