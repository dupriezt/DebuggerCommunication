Class {
	#name : #RBProgramNodeRepresentation,
	#superclass : #Representation,
	#category : #DebuggerCommunication
}

{ #category : #'as yet unclassified' }
RBProgramNodeRepresentation >> gtInspectorSourceCodeIn: composite [
	<gtInspectorPresentationOrder: 0> 

	^ composite pharoMethod 
		title: [ 'Source code' translated ];
		display: [ self at: #methodSourceCode ];
		"smalltalkClass: [ 
			self parents first compilationContext ifNotNil: [ :ctx | ctx getClass ] ]; "
		initialize: [ :presentation | 
			presentation selectionInterval: ((self at: #start) to: (self at: #stop)) ];
		when: [ (self at: #methodSourceCode) notNil ];
		act: [ self inform: 'hello' "self methodNode method compiledMethod browse"] icon: GLMUIThemeExtraIcons glamorousBrowse entitled: 'Browse'
]

{ #category : #testing }
RBProgramNodeRepresentation >> isMessage [
	^ self at: #nodeType = 'RBMessageNode'
]

{ #category : #comparison }
RBProgramNodeRepresentation >> keysToIgnoreForComparison [
	^ { #methodSourceCode }
]
