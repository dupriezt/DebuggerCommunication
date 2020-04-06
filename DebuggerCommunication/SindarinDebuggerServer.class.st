"
Contains a SindarinDebugger. Listens on a port. Receives instances of SindarinRequest from a SindarinDebuggerClient and executes them on the SindarinDebugger it holds.
"
Class {
	#name : #SindarinDebuggerServer,
	#superclass : #Object,
	#instVars : [
		'sindarinDebugger',
		'server'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerServer class >> newOnSindarinDebugger: aSindarinDebugger [
	^ self new newOnSindarinDebugger: aSindarinDebugger.
]

{ #category : #communication }
SindarinDebuggerServer class >> stopAll [
	self allInstancesDo: [ :inst | inst stop ].
]

{ #category : #public }
SindarinDebuggerServer >> handleRequest: aRequest [
	^ aRequest executeOn: self.
]

{ #category : #public }
SindarinDebuggerServer >> materialiseRequest: serialisedRequest [
	^ FLMaterializer materializeFromByteArray: serialisedRequest.
]

{ #category : #'instance creation' }
SindarinDebuggerServer >> newOnSindarinDebugger: aSindarinDebugger [
	sindarinDebugger := aSindarinDebugger.
	"Work around the issue that #activeProcess is wrong when the method that uses it is stepped by different processes (like it is when remotely stepped: each step is one process). Basically, the process that steps the #activeProcess gets put on the value stack, dies, then whatever the method wanted to do with the active process will be done to that dead process instead of the actual active process (the process currently stepping the method).
	The big example is when the debugged process calls #terminateActive to end its life: it terminates an already dead stepper process instead of itself, and this wreaks havoc."
	sindarinDebugger addStepHook: [ (sindarinDebugger method selector = #terminateActive) ifTrue: [ sindarinDebugger step ] ].
	^ self.
]

{ #category : #public }
SindarinDebuggerServer >> serialise: anObject [
	^ STON toString: anObject
]

{ #category : #accessing }
SindarinDebuggerServer >> sindarinDebugger [
	^ sindarinDebugger
]

{ #category : #public }
SindarinDebuggerServer >> startListeningOnPort: anInt [
	| request |
	server := ZnServer startOn: anInt.
	server
		onRequestRespond: [ :req | | result serialisation |
			request := self materialiseRequest: req entity bytes.
			request isPing ifTrue: [
				ZnResponse ok: (ZnStringEntity text: request correctResponse) ]
			ifFalse: [
				result := [[ self handleRequest: request ] on: UnhandledExceptionSignalledByADebuggedExecution do: [ :e | e "If the error is that the debugged execution signalled an unhandled exception, we answer the client's request with this exception  so that an exception can be signalled in the client image"]] on: Error do: [ :e | e resignalAs: Halt ].
				"result := [ self handleRequest: request]
					on: Error
					do: [ :e | e resignalAs: Halt ]."
				serialisation := [self serialise: result]
					on: Error
					do: [ :e | e resignalAs: Halt ].
				ZnResponse ok: (ZnStringEntity text: serialisation) ]]
]

{ #category : #public }
SindarinDebuggerServer >> stop [
	server stop.
]
