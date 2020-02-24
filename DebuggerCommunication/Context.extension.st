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
	receiver := self receiver.
	dict at: #receiver put: ([receiver asString] on: Error do: [:e | 'Not Printable. Error: ', e asString]).
	dict at: #method put: self method asString.
	"stonWriter writeString: 'Context'."
	dict stonOn: stonWriter.
]
