Extension { #name : #Exception }

{ #category : #'*DebuggerCommunication' }
Exception >> stonOn: stonWriter [
	| dict |
	dict := ExceptionRepresentation new.
	dict at: #exceptionClass put: (self class asString).
	dict at: #messageText put: messageText.
	dict at: #tag put: tag.
	dict at: #signaler put: (signaler asString).
	dict at: #signalContext put: signalContext.
	dict at: #handlerContet put: handlerContext.
	dict at: #outerContext put: outerContext.
	dict stonOn: stonWriter.
]
