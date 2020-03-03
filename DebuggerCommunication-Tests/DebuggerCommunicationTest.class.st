Class {
	#name : #DebuggerCommunicationTest,
	#superclass : #TestCase,
	#instVars : [
		'dbg',
		'dbgServer',
		'dbgp',
		'dbgl',
		'dbgc'
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
	dbgc := SindarinDebuggerClient newOnPort: port.
	dbgp := SindarinDebuggerProxyClient newOnSindarinDebuggerClient: dbgc.
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

{ #category : #tests }
DebuggerCommunicationTest >> testSerialiseASTNode [
	| astNodeRepresentation |
	astNodeRepresentation := dbgc sendRequest: TestRequestReturnASTNode new.
	self assert: (astNodeRepresentation at: #source) equals: 'self myMessage: 25'.
	self assert: (astNodeRepresentation at: #class) equals: 'TestRequestReturnASTNode'.
	self assert: (astNodeRepresentation at: #nodeType) equals: 'RBMessageNode'.
	self assert: (astNodeRepresentation at: #stop) equals: 30.
	self assert: (astNodeRepresentation at: #start) equals: 13.
	self assert: (astNodeRepresentation at: #methodSourceCode) equals: 'testMethod
	self myMessage: 25'.
	self assert: (astNodeRepresentation at: #methodSelector) equals: #testMethod.
]

{ #category : #tests }
DebuggerCommunicationTest >> testSerialiseBlockClosure [
	| blockClosure |
	"Serialising a BlockClosure does not work at the moment"
	blockClosure := dbgc sendRequest: TestRequestReturnBlockClosure new.
	self assert: blockClosure value equals: 42.
]

{ #category : #tests }
DebuggerCommunicationTest >> testSerialiseContext [
	| contextRepresentation nodeRepresentation |
	contextRepresentation := dbgc sendRequest: TestRequestReturnContext new.
	self assert: (contextRepresentation at: #receiver) equals: 'a TestRequestReturnContext'.
	self assert: (contextRepresentation at: #method) equals: 'executeOn: aDebuggerServer
	^ thisContext'.
	nodeRepresentation := contextRepresentation at: #node.
	self assert: (nodeRepresentation at: #source) equals: 'executeOn: aDebuggerServer
	^ thisContext'.
	self assert: (nodeRepresentation at: #nodeType) equals: 'RBMethodNode'.
]

{ #category : #tests }
DebuggerCommunicationTest >> testSerialiseInteger [
	self assert: (dbgc sendRequest: TestRequestReturnFive new) equals: 5.
]
