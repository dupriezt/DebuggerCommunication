Class {
	#name : #EchoDebugger,
	#superclass : #Object,
	#instVars : [
		'proxyClientForWorkingExec',
		'proxyClientForFailingExec'
	],
	#category : #DebuggerCommunication
}

{ #category : #testing }
EchoDebugger >> isOnSameNode [
	^ proxyClientForWorkingExec node = proxyClientForFailingExec node
]

{ #category : #accessing }
EchoDebugger >> nodes [
	| result |
	result := Dictionary new.
	result at: #nodeOfWorkingExec put: proxyClientForWorkingExec node.
	result at: #nodeOfFailingExec put: proxyClientForFailingExec node.
	^ result
]

{ #category : #operation }
EchoDebugger >> parallelStepUntilDivergence [
	"Step both executions until they are not on the same node, or one of them is finished. Return the list of the ast nodes that were encountered by both executions, including the starting node"
	| steppedNodes |
	steppedNodes := OrderedCollection new.
	[ self isOnSameNode & proxyClientForWorkingExec isExecutionFinished not & proxyClientForFailingExec isExecutionFinished not ] whileTrue: [ steppedNodes add: proxyClientForWorkingExec node. proxyClientForWorkingExec step. proxyClientForFailingExec step. ].
	^ steppedNodes.
]

{ #category : #accessing }
EchoDebugger >> proxyClientForFailingExec [
	^ proxyClientForFailingExec
]

{ #category : #accessing }
EchoDebugger >> proxyClientForFailingExec: anObject [
	proxyClientForFailingExec := anObject
]

{ #category : #accessing }
EchoDebugger >> proxyClientForWorkingExec [
	^ proxyClientForWorkingExec
]

{ #category : #accessing }
EchoDebugger >> proxyClientForWorkingExec: anObject [
	proxyClientForWorkingExec := anObject
]

{ #category : #operation }
EchoDebugger >> stepToSenderContext [
	"Step both executions until the size of their context stack is one less than currently. Return a dictionary containing the nodes stepped by each execution, and whether they ended up on the same node"
	| result stackSizeGoal_working stackSizeGoal_failing |
	stackSizeGoal_working := proxyClientForWorkingExec stack size - 1.
	stackSizeGoal_failing := proxyClientForWorkingExec stack size - 1.
	(stackSizeGoal_working = 0 or: [ stackSizeGoal_failing = 0 ]) ifTrue: [ self error: 'Trying to step until context stack is empty' ].
	result := Dictionary new.
	
	result at: #steppedNodes_working put: OrderedCollection new.
	[proxyClientForWorkingExec stack size = stackSizeGoal_working] whileFalse: [ (result at: #steppedNodes_working) add: proxyClientForWorkingExec node. proxyClientForWorkingExec step ].
	
	result at: #steppedNodes_failing put: OrderedCollection new.
	[ proxyClientForFailingExec stack size = stackSizeGoal_failing ] whileFalse: [ (result at: #steppedNodes_failing) add: proxyClientForFailingExec node. proxyClientForFailingExec step ].

	result at: #onSameNode put: (self isOnSameNode).
	^ result
	
]
