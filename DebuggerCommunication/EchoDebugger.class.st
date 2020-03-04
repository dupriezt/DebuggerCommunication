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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
EchoDebugger >> stepToSenderContext [
	| senderContext_working senderContext_failing result |
	senderContext_working := proxyClientForWorkingExec stack at: 2.
	senderContext_failing := proxyClientForFailingExec stack at: 2.
	result := Dictionary new.
	
	result at: #steppedNodes_working put: OrderedCollection new.
	[proxyClientForWorkingExec context = senderContext_working] whileFalse: [ (result at: #steppedNodes_working) add: proxyClientForWorkingExec node. proxyClientForWorkingExec step ].
	
	result at: #steppedNodes_failing put: OrderedCollection new.
	[ proxyClientForFailingExec context = senderContext_failing ] whileFalse: [ (result at: #steppedNodes_failing) add: proxyClientForFailingExec node. proxyClientForFailingExec step ].

	result at: #onSameNode put: (self isOnSameNode).
	^ result
	
]
