Extension { #name : #BlockClosure }

{ #category : #'*DebuggerCommunication' }
BlockClosure >> fromSton: stonReader [
	stonReader parseListDo: [ :each :index |
		index = 1 ifTrue: [ outerContext := each ].
	]
]

{ #category : #'*DebuggerCommunication' }
BlockClosure >> stonOn: stonWriter [
	stonWriter writeObject: self streamShortList: [ :array | array add: outerContext selector ]
]
