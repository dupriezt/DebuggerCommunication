Extension { #name : #Context }

{ #category : #'*DebuggerCommunication' }
Context >> fromSton: stonReader [
	stonReader parseListDo: [ :each :index |
		index = 1 ifTrue: [ receiver := each ].
	]
]

{ #category : #'*DebuggerCommunication' }
Context >> stonOn: stonWriter [
	stonWriter writeObject: self streamShortList: [ :array | array add: receiver ]
]
