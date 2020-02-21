Extension { #name : #RBProgramNode }

{ #category : #'*DebuggerCommunication' }
RBProgramNode >> stonOn: stonWriter [
	| dict |
	dict := Dictionary new.
	dict at: #start put: self start.
	dict at: #stop put: self stop.
	dict at: #methodSelector put: self methodNode selector.
	dict at: #nodeType put: self class asString.
	stonWriter writeString: 'RBProgramNode'.
	stonWriter writeObject: dict.
]
