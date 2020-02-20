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
DebuggerServer >> serialise: anObject [
	^ STON toString: anObject
]

{ #category : #public }
DebuggerServer >> startListeningOnPort: anInt [
	server := ZnServer startOn: anInt.
	server
		onRequestRespond: [ :req | | result serialisation |
			result := [ self handleRequest: req entity bytes ]
				on: Error
				do: [ :e | self halt: 'result' ].
			serialisation := [self serialise: result]
				on: Error
				do: [ :e | self halt: 'serialisation' ].
			self halt.
			ZnResponse ok: serialisation ]
]

{ #category : #public }
DebuggerServer >> stop [
	server stop.
]
