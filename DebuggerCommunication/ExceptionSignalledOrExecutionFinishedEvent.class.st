Class {
	#name : #ExceptionSignalledOrExecutionFinishedEvent,
	#superclass : #EchoDebuggerDataEvent,
	#category : #DebuggerCommunication
}

{ #category : #'as yet unclassified' }
ExceptionSignalledOrExecutionFinishedEvent >> nature [
	^ 'Exc or End' "Exception or Execution Finished'"
]
