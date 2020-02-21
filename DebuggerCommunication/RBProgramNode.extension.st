Extension { #name : #RBProgramNode }

{ #category : #'*DebuggerCommunication' }
RBProgramNode >> stonOn: stonWriter [
	| dict |
	dict := Dictionary new.
	dict at: #start put: self start.
	dict at: #stop put: self stop.
	dict at: #methodSelector put: self methodNode selector.
	stonWriter writeObject: dict.
]
