Class {
	#name : #ContextRepresentation,
	#superclass : #Representation,
	#category : #DebuggerCommunication
}

{ #category : #comparison }
ContextRepresentation >> keysToIgnoreForComparison [
	^ { #node }
]
