Class {
	#name : #RBProgramNodeRepresentation,
	#superclass : #Representation,
	#category : #DebuggerCommunication
}

{ #category : #comparison }
RBProgramNodeRepresentation >> keysToIgnoreForComparison [
	^ { #methodSourceCode }
]
