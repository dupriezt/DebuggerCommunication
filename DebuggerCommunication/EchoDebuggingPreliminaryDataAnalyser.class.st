Class {
	#name : #EchoDebuggingPreliminaryDataAnalyser,
	#superclass : #Object,
	#instVars : [
		'preliminaryDataWorkingExec',
		'preliminaryDataFailingExec',
		'stepCounterW',
		'stepCounterF',
		'sizeOfDataForWExec',
		'sizeOfDataForFExec'
	],
	#category : #DebuggerCommunication
}

{ #category : #'as yet unclassified' }
EchoDebuggingPreliminaryDataAnalyser >> performAnalysis [
	"preliminaryDataWorkingExec and  preliminaryDataFailingExec are expected to be of the form: an array containing an item per step the execution took to finish. Each item is an array of size 2: first element is the hash of the current ast node, second element is the size of the stack at that step."
	| convergent analysisResult stepDataW stepDataF convergent_newValue |
	stepCounterW := 1.
	stepCounterF := 1.
	convergent := true.
	analysisResult := OrderedCollection new.
	[[ true ] whileTrue: [ "Stopping condition is signaling an ReachedEndOfPreliminaryDataForExecution exception which will get caught in the handler surrounding this while block"
		stepDataW := preliminaryDataWorkingExec at: stepCounterW.
		stepDataF := preliminaryDataFailingExec at: stepCounterF.
		(stepDataW = stepDataF) ifTrue: [
			"The executions are currently convergent"
			convergent_newValue := true.
			convergent ifFalse: [ 
				"The executions were divergent and are now convergent. Adding this point to analysisResult"	
				analysisResult add: { 'convergence'. stepCounterW. stepCounterF}.
			]
		] ifFalse: [ 
			"The executions are currently divergent"
			convergent_newValue := false.
			convergent ifTrue: [ 
				"The executions were convergent and are now convergent. Adding this point to analysisResult"
				analysisResult add: { 'divergence'. stepCounterW. stepCounterF}.
			].
		].
		convergent := convergent_newValue.
		convergent ifTrue: [
			"The executions are currently convergent. Stepping them both once."
			self stepWExec.
			self stepFExec.
		] ifFalse: [ |stackSizeWExec stackSizeFExec|
			"The executions are divergent. Stepping one of them (or both) until their stack size is lower"
			stackSizeWExec := self stackSizeWExec.
			stackSizeFExec := self stackSizeFExec.
			(stackSizeWExec = stackSizeFExec) ifTrue: [
				"The executions have the same stack size. Stepping both executions until their stack size is 1 less"
				self stepWExecUntilStackSizeIs: stackSizeWExec - 1.
				self stepFExecUntilStackSizeIs: stackSizeFExec - 1.
			] ifFalse: [
				"The execution have different stack sizes. Stepping the execution with the largest stack until its stack size is 1 less"
				(stackSizeWExec < stackSizeFExec) ifTrue: [ 
					"Failing execution has the largest stack"
					self stepFExecUntilStackSizeIs: stackSizeFExec - 1.
				] ifFalse: [ 
					"Working execution has the largest stack"
					self stepWExecUntilStackSizeIs: stackSizeWExec - 1.
				].
			]
		].
	]] on: ReachedEndOfPreliminaryDataForExecution do: [ ^ analysisResult ]
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> preliminaryDataFailingExec [
	^ preliminaryDataFailingExec
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> preliminaryDataFailingExec: anObject [
	preliminaryDataFailingExec := anObject.
	sizeOfDataForFExec := preliminaryDataFailingExec size.
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> preliminaryDataWorkingExec [
	^ preliminaryDataWorkingExec
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> preliminaryDataWorkingExec: anObject [
	preliminaryDataWorkingExec := anObject.
	sizeOfDataForWExec := preliminaryDataWorkingExec size.
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stackSizeFExec [
	"Returns the size of the stack of the failing execution at the current step"
	^ (preliminaryDataFailingExec at: stepCounterF) at: 2
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stackSizeWExec [
	"Returns the size of the stack of the working execution at the current step"
	^ (preliminaryDataWorkingExec at: stepCounterW) at: 2
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stepFExec [
	"Step the failing execution once"
	(stepCounterF = sizeOfDataForFExec) ifTrue: [ ReachedEndOfPreliminaryDataForExecution signal ].
	stepCounterF := stepCounterF + 1
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stepFExecUntilStackSizeIs: stackSizeGoal [
	"stackSizeGoal: an integer"
	[self stackSizeFExec ~= stackSizeGoal] whileTrue: [ self stepFExec ].
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stepWExec [
	"Step the working execution once"
	(stepCounterW = sizeOfDataForWExec) ifTrue: [ ReachedEndOfPreliminaryDataForExecution signal ].
	stepCounterW := stepCounterW + 1
]

{ #category : #accessing }
EchoDebuggingPreliminaryDataAnalyser >> stepWExecUntilStackSizeIs: stackSizeGoal [
	"stackSizeGoal: an integer"
	[self stackSizeWExec ~= stackSizeGoal] whileTrue: [ self stepWExec ].
]
