Class {
	#name : #NetworkRequest,
	#superclass : #Object,
	#category : #DebuggerCommunication
}

{ #category : #execution }
NetworkRequest >> executeOn: aDebuggerServer [
	self subclassResponsibility
]

{ #category : #accessing }
NetworkRequest >> isPing [
	^ false
]

{ #category : #accessing }
NetworkRequest >> serialized [
	^ FLSerializer serializeToByteArray: self.
]
