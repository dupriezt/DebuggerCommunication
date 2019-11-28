Class {
	#name : #BaselineOfDebuggerCommunication,
	#superclass : #BaselineOf,
	#category : #BaselineOfDebuggerCommunication
}

{ #category : #baselines }
BaselineOfDebuggerCommunication >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec baseline: 'Sindarin' with: [ spec repository: 'github://dupriezt/ScriptableDebugger' ].
		spec package: 'DebuggerCommunication'.
		spec package: 'DebuggerCommunication-Tests'
	].
"			package: 'Commander2-Tests' with: [ spec requires: #('Commander2') ] ]"
]
