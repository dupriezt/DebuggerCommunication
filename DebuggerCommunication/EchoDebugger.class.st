Class {
	#name : #EchoDebugger,
	#superclass : #Object,
	#instVars : [
		'proxyClientForWorkingExec',
		'proxyClientForFailingExec',
		'data'
	],
	#category : #DebuggerCommunication
}

{ #category : #initialization }
EchoDebugger >> analyzeExecution [
	"Assumes the executions are both at the beginning"
	| roundNumber startStepIndex_w paraStepRes startStepIndex_f converge stepIndexIncrement_w stepIndexIncrement_f event stepToConvergenceRes nodes_w nodes_f |
	roundNumber := 1.
	converge := true.
	[ (proxyClientForWorkingExec isExecutionFinished or: [ proxyClientForFailingExec isExecutionFinished ]) ] whileFalse: [ 
		startStepIndex_w := (data at: roundNumber) index_working.
		startStepIndex_f := (data at: roundNumber) index_failing.
		stepIndexIncrement_w := 0.
		stepIndexIncrement_f := 0.
		converge ifTrue: [ 
			paraStepRes := self parallelStepUntilDivergence.
			stepIndexIncrement_w := paraStepRes size.
			stepIndexIncrement_f := paraStepRes size.
			nodes_w := paraStepRes.
			nodes_f := paraStepRes.
			event := DivergenceEvent new.
		 ] ifFalse: [ 
			stepToConvergenceRes := self stepToSenderContextUntilConvergence.
			stepIndexIncrement_w := (stepToConvergenceRes at: #steppedNodes_working) size.
			stepIndexIncrement_f := (stepToConvergenceRes at: #steppedNodes_failing) size.
			nodes_w := (stepToConvergenceRes at: #steppedNodes_working).
			nodes_f := (stepToConvergenceRes at: #steppedNodes_failing).
			event := ConvergenceEvent new.
		].
		event index_working: startStepIndex_w + stepIndexIncrement_w.
		event index_failing: startStepIndex_f + stepIndexIncrement_f.
		event nodes_working: nodes_w.
		event nodes_failing: nodes_f.
		data add: event.
		roundNumber := roundNumber + 1.
		converge := converge not.
		self halt.
	].
]

{ #category : #accessing }
EchoDebugger >> data [
	^ data
]

{ #category : #'as yet unclassified' }
EchoDebugger >> eitherExecutionIsFinished [
	^ proxyClientForFailingExec isExecutionFinished or: [ proxyClientForWorkingExec isExecutionFinished ]
]

{ #category : #initialization }
EchoDebugger >> initialize [
	| conv |
	data := EchoDebuggerData new.
	conv := ConvergenceEvent new.
	conv index_working: 0; index_failing: 0; nodes_working: OrderedCollection new; nodes_failing: OrderedCollection new.
	data add: conv.
]

{ #category : #testing }
EchoDebugger >> isBothDebuggersConnected [
	^ proxyClientForFailingExec isNotNil & proxyClientForWorkingExec isNotNil
]

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
	[ self isOnSameNode & proxyClientForWorkingExec isExecutionFinished not & proxyClientForFailingExec isExecutionFinished not ] whileTrue: [ steppedNodes add: proxyClientForWorkingExec node. self stepWorkingExec. self stepFailingExec. ].
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
EchoDebugger >> stepFailingExec [

"	proxyClientForFailingExec step."
	proxyClientForFailingExec stepBytecode.
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
	[proxyClientForWorkingExec stack size = stackSizeGoal_working] whileFalse: [ (result at: #steppedNodes_working) add: proxyClientForWorkingExec node. self stepWorkingExec ].
	
	result at: #steppedNodes_failing put: OrderedCollection new.
	[ proxyClientForFailingExec stack size = stackSizeGoal_failing ] whileFalse: [ (result at: #steppedNodes_failing) add: proxyClientForFailingExec node. self stepFailingExec ].

	result at: #onSameNode put: (self isOnSameNode).
	^ result
	
]

{ #category : #operation }
EchoDebugger >> stepToSenderContextUntilConvergence [
	| result stepToSenderRes |
	result := Dictionary new.
	result at: #steppedNodes_working put: OrderedCollection new.
	result at: #steppedNodes_failing put: OrderedCollection new.
	
	stepToSenderRes := self stepToSenderContext.
	result at: #steppedNodes_working put: ((result at: #steppedNodes_working), (stepToSenderRes at: #steppedNodes_working)).
	result at: #steppedNodes_failing put: ((result at: #steppedNodes_failing), (stepToSenderRes at: #steppedNodes_failing)).
	[(stepToSenderRes at: #onSameNode) or: [self eitherExecutionIsFinished]] whileFalse: [ 
		stepToSenderRes := self stepToSenderContext.
		result at: #steppedNodes_working put: ((result at: #steppedNodes_working), (stepToSenderRes at: #steppedNodes_working)).
		result at: #steppedNodes_failing put: ((result at: #steppedNodes_failing), (stepToSenderRes at: #steppedNodes_failing)).
	].
	^ result.
	
]

{ #category : #operation }
EchoDebugger >> stepWorkingExec [
	
"	proxyClientForWorkingExec step"
	proxyClientForWorkingExec stepBytecode
]
