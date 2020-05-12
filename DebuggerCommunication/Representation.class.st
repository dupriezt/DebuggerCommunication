Class {
	#name : #Representation,
	#superclass : #Dictionary,
	#category : #DebuggerCommunication
}

{ #category : #comparison }
Representation >> = aRBProgramNodeRepresentation [
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

{ #category : #comparison }
Representation >> hash [
	"Same #hash as Dictionary, but ignoring keys in keysToIgnoreForComparison
	
	Answer an integer hash value for the receiver such that,
	  -- the hash value of an unchanged object is constant over time, and
	  -- two equal objects have equal hash values"

	| hash |

	hash := self species name hash. "Hashing the name of the species (= self class) instead of hasing the species, so that it gives the same result in two different images"
	self size <= 10 ifTrue:
		[self associationsDo: [:assoc | (self keysToIgnoreForComparison includes: assoc key) ifFalse: [hash := hash bitXor: assoc value hash]]].
	^hash bitXor: self size hash
]

{ #category : #comparison }
Representation >> keysToIgnoreForComparison [
	^ {  }
]
