Class {
	#name : #BaselineOfDebuggerCommunication,
	#superclass : #BaselineOf,
	#category : #BaselineOfDebuggerCommunication
}

{ #category : #baselines }
BaselineOfDebuggerCommunication >> baseline: spec [
	<baseline>
	| repository |
	repository := self packageRepositoryURL.
	spec for: #common do: [ 
		spec baseline: 'ScriptableDebugger' with: [ spec repository: repository ].
		spec package: 'DebuggerCommunication'.
	].
"			package: 'Commander2-Tests' with: [ spec requires: #('Commander2') ] ]"
]
