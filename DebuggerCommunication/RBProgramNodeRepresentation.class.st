Class {
	#name : #RBProgramNodeRepresentation,
	#superclass : #Dictionary,
	#category : #DebuggerCommunication
}

{ #category : #'as yet unclassified' }
RBProgramNodeRepresentation >> = aRBProgramNodeRepresentation [
	"Two dictionaries are equal if
	 (a) they are the same 'kind' of thing.
	 (b) they have the same set of keys.
	 (c) for each (common) key, they have the same value.
	See issue 16760 before changing"

	self == aRBProgramNodeRepresentation ifTrue: [^true].
	self species == aRBProgramNodeRepresentation species ifFalse: [^false].
	self size = aRBProgramNodeRepresentation size ifFalse: [^false].
	self associationsDo: [:assoc|
		((self keysToIgnoreForComparison) includes: (assoc key)) ifFalse: [
			(aRBProgramNodeRepresentation at: assoc key ifAbsent: [^false]) = assoc value
			ifFalse: [^false]]
		].
	^true
]

{ #category : #'as yet unclassified' }
RBProgramNodeRepresentation >> keysToIgnoreForComparison [
	^ { #methodSourceCode }
]
