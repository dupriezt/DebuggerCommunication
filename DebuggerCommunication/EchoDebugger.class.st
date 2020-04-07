Class {
	#name : #EchoDebugger,
	#superclass : #Object,
	#instVars : [
		'proxyClientForWorkingExec',
		'proxyClientForFailingExec',
		'data',
		'stepCounterWorkingExec',
		'stepCounterFailingExec',
		'focusedMethodNames'
	],
	#category : #DebuggerCommunication
}

{ #category : #initialization }
EchoDebugger >> analyzeExecution [
	"Assumes the executions are both at the beginning"
	| roundNumber startStepIndex_w paraStepRes startStepIndex_f converge stepIndexIncrement_w stepIndexIncrement_f event stepToConvergenceRes nodes_w nodes_f |
	roundNumber := 1.
	converge := true.
	"[ (proxyClientForWorkingExec isExecutionFinished or: [ proxyClientForFailingExec isExecutionFinished ]) ] whileFalse: [ "
	[[ true ] whileTrue: [ 
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
		event index_working: stepCounterWorkingExec "startStepIndex_w + stepIndexIncrement_w".
		event index_failing: stepCounterFailingExec "startStepIndex_f + stepIndexIncrement_f".
		event nodes_working: nodes_w.
		event nodes_failing: nodes_f.
		data add: event.
		roundNumber := roundNumber + 1.
		converge := converge not.
	]] on: DebuggedExecutionException do: [
		event := ExceptionSignalledOrExecutionFinishedEvent new.
		event index_working: stepCounterWorkingExec.
		event index_failing: stepCounterFailingExec.
		event nodes_working: OrderedCollection new. self flag: 'these fields do not make sense for this event'.
		event nodes_failing: OrderedCollection new.
		data add: event. 
	]
]

{ #category : #accessing }
EchoDebugger >> data [
	^ data
]

{ #category : #'as yet unclassified' }
EchoDebugger >> eitherExecutionIsFinished [
	^ proxyClientForFailingExec isExecutionFinished or: [ proxyClientForWorkingExec isExecutionFinished ]
]

{ #category : #'as yet unclassified' }
EchoDebugger >> eventIfEitherExecutionIsOnNodeOfFocusedMethod [
	| nodeWorking fullSelectorWorkingExec nodeFailing fullSelectorFailingExec event |
	nodeWorking := proxyClientForWorkingExec node.
	fullSelectorWorkingExec := (nodeWorking at: #class), '>>#', (nodeWorking at: #methodSelector).
	nodeFailing := proxyClientForFailingExec node.
	fullSelectorFailingExec := (nodeFailing at: #class), '>>#', (nodeFailing at: #methodSelector).
	((focusedMethodNames includes: fullSelectorWorkingExec) or: [focusedMethodNames includes: fullSelectorFailingExec]) ifTrue: [
		"We reached a node belonging to a method in the focus list"
		event := NodeOfFocusedMethodReachedEvent new.
		event 	index_failing: stepCounterFailingExec.
		event index_working: stepCounterWorkingExec.
		self data add: event.
	]
]

{ #category : #initialization }
EchoDebugger >> focusedMethodNames [
	^ focusedMethodNames
]

{ #category : #'as yet unclassified' }
EchoDebugger >> goToEvent: anEchoDebuggerDataEvent [
	"Restart both executions and step them until reaching the same number of steps @anEchoDebuggerDataEvent has occured at"
	| event |
	event := anEchoDebuggerDataEvent.
	proxyClientForFailingExec restart.
	proxyClientForWorkingExec restart.
	
	event index_working timesRepeat: [ proxyClientForWorkingExec step ].
	event index_failing timesRepeat: [ proxyClientForFailingExec step ].
	
]

{ #category : #initialization }
EchoDebugger >> initialize [
	self resetEchoDebugging.
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
	[ self isOnSameNode ] whileTrue: [ steppedNodes add: proxyClientForWorkingExec node. self stepWorkingExec. self stepFailingExec. self eventIfEitherExecutionIsOnNodeOfFocusedMethod].
	^ steppedNodes.
	
	"steppedNodes := OrderedCollection new.
	[ self isOnSameNode & proxyClientForWorkingExec isExecutionFinished not & proxyClientForFailingExec isExecutionFinished not ] whileTrue: [ steppedNodes add: proxyClientForWorkingExec node. self stepWorkingExec. self stepFailingExec. ].
	^ steppedNodes."
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

{ #category : #initialization }
EchoDebugger >> resetData [
	| conv |
	data := EchoDebuggerData new.
	conv := ConvergenceEvent new.
	conv index_working: 0; index_failing: 0; nodes_working: OrderedCollection new; nodes_failing: OrderedCollection new.
	data add: conv.
]

{ #category : #initialization }
EchoDebugger >> resetEchoDebugging [
	self resetStepCounters.
	self resetData.
	focusedMethodNames := OrderedCollection new.
]

{ #category : #initialization }
EchoDebugger >> resetStepCounters [
	stepCounterWorkingExec := 0.
	stepCounterFailingExec := 0
]

{ #category : #operation }
EchoDebugger >> stepFailingExec [

	"(proxyClientForFailingExec isExecutionFinished or: [ proxyClientForFailingExec isAboutToSignalException  ]) ifTrue: [ RemoteExecutionCannotBeStepped signal ]."
	| node event |
	proxyClientForFailingExec step.
	stepCounterFailingExec := stepCounterFailingExec + 1.
]

{ #category : #operation }
EchoDebugger >> stepToSenderContext [
	"Step both executions until the size of their context stack is one less than currently. Return a dictionary containing the nodes stepped by each execution, and whether they ended up on the same node"
	| result stackSizeGoal_working stackSizeGoal_failing workingStackSize failingStackSize |
	workingStackSize := proxyClientForWorkingExec stack size.
	failingStackSize := proxyClientForFailingExec stack size.
	(workingStackSize = failingStackSize) ifTrue: [ 
		stackSizeGoal_working := workingStackSize - 1.
		stackSizeGoal_failing := stackSizeGoal_working.
	] ifFalse: [ 
		(workingStackSize < failingStackSize) ifTrue: [ 
			stackSizeGoal_working := workingStackSize.
			stackSizeGoal_failing := failingStackSize - 1.
		] ifFalse: [ "workingStackSize > failingStackSize"
			stackSizeGoal_working := workingStackSize - 1.
			stackSizeGoal_failing := failingStackSize.
		]
	].
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
	[(stepToSenderRes at: #onSameNode) "or: [self eitherExecutionIsFinished]"] whileFalse: [ 
		stepToSenderRes := self stepToSenderContext.
		result at: #steppedNodes_working put: ((result at: #steppedNodes_working), (stepToSenderRes at: #steppedNodes_working)).
		result at: #steppedNodes_failing put: ((result at: #steppedNodes_failing), (stepToSenderRes at: #steppedNodes_failing)).
	].
	^ result.
	
]

{ #category : #operation }
EchoDebugger >> stepWorkingExec [

	"(proxyClientForWorkingExec isExecutionFinished or: [ proxyClientForWorkingExec isAboutToSignalException  ]) ifTrue: [ RemoteExecutionCannotBeStepped signal ]."
	| node event |
	proxyClientForWorkingExec step.
	stepCounterWorkingExec := stepCounterWorkingExec + 1.
]
