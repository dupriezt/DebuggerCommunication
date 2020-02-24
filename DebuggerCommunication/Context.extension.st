Extension { #name : #Context }

{ #category : #'*DebuggerCommunication' }
Context >> fromSton: stonReader [
	stonReader parseListDo: [ :each :index |
		index = 1 ifTrue: [ receiver := each ].
	]
]

{ #category : #'*DebuggerCommunication' }
Context >> stonOn: stonWriter [
	| dict |
	dict := ContextRepresentation new.
	dict at: #receiver put: self receiver asString.
	dict at: #method put: self method asString.
	"stonWriter writeString: 'Context'."
	dict stonOn: stonWriter.
]
