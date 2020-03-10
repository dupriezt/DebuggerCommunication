Class {
	#name : #PingRequest,
	#superclass : #NetworkRequest,
	#category : #DebuggerCommunication
}

{ #category : #accessing }
PingRequest >> correctResponse [
	^ 'pong'
]

{ #category : #accessing }
PingRequest >> isPing [
	^ true
]
