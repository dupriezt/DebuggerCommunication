Class {
	#name : #DebuggerCommunicationTest,
	#superclass : #TestCase,
	#instVars : [
		'dbg',
		'dbgServer',
		'dbgp',
		'dbgl'
	],
	#category : #'DebuggerCommunication-Tests'
}

{ #category : #tests }
DebuggerCommunicationTest >> areExecutionsAtTheSamePoint [
	^ dbgl node = dbgp node
]

{ #category : #running }
DebuggerCommunicationTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	| port |
	port := 8246.
	
	"Debugger on the local execution"
	dbgl := SindarinDebugger debug: [  Point x: 1 y: 2 ].
	
	"Debugger on the remotely-controlled execution"
	dbg := SindarinDebugger debug: [ Point x: 1 y: 2 ].
	dbgServer := SindarinDebuggerServer newOnSindarinDebugger: dbg.
	dbgServer startListeningOnPort: port.
	
	"Proxy debugger on the debugger controlling the remotely-controlled execution"
	dbgp := SindarinDebuggerProxyClient newOnSindarinDebuggerClient: (SindarinDebuggerClient newOnPort: port).
]

{ #category : #tests }
DebuggerCommunicationTest >> testExecutionIsFinished [
	"Tests that the end of the execution is correctly detected by the remote execution"
	[dbgl isExecutionFinished | dbgp isExecutionFinished ] whileFalse: [ 
		dbgl step.
		dbgp step
	].
	"If one execution finished, both must have finished"
	self assert: dbgl isExecutionFinished & dbgp isExecutionFinished.
	self assert: self areExecutionsAtTheSamePoint.
	
]

{ #category : #tests }
DebuggerCommunicationTest >> testSameAfterStep [
	"Tests that after a step, the local and remotely-controlled execution are at the same point"
	dbgl step.
	dbgp step.
	self assert: self areExecutionsAtTheSamePoint
]

{ #category : #tests }
DebuggerCommunicationTest >> testSameStart [
	"Test that both the local and remotely-controlled execution start at the same point"
	self assert: self areExecutionsAtTheSamePoint.
]
