Class {
	#name : #ExceptionRepresentation,
	#superclass : #Representation,
	#category : #DebuggerCommunication
}

{ #category : #testing }
ExceptionRepresentation >> isExceptionSignalledForDebuggedExecution [
	"Returns whether the #exceptionClass of the represented exception is equal to #DebuggedExecutionException, or the name of one of its subclasses"
	self flag: 'Can be rewritten using SmalltalkImage>>#classNamed:'.
	((DebuggedExecutionException subclasses collect: [ :clas | clas asString ]) includes: (self at: #exceptionClass)) ifTrue: [ ^ true ].
	((self at: #exceptionClass) = DebuggedExecutionException asString) ifTrue: [ ^true ].
	^ false
]
