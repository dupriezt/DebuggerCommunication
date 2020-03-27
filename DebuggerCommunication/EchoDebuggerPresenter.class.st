Class {
	#name : #EchoDebuggerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'pointTable',
		'textField',
		'executeButton',
		'inspectButton',
		'stepToNextDivergenceButton',
		'stepToSenderContextButton',
		'workingExecutionPresenter',
		'failingExecutionPresenter',
		'echoDebugger',
		'statusViewer',
		'initialPortWorkingExecution',
		'initialPortFailingExecution',
		'analyzeExecutionButton',
		'dataViewer',
		'stepToSenderContextUntilConvergenceButton',
		'inspectEchoDebuggerButton'
	],
	#category : #DebuggerCommunication
}

{ #category : #specs }
EchoDebuggerPresenter class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #specs }
EchoDebuggerPresenter class >> open [
	<script>
	(self on: nil "model object, will be used as argument in #setModelBeforeInitialization:") openWithSpec.
]

{ #category : #specs }
EchoDebuggerPresenter class >> openOnPort [
	<script>
	(self on: {'5007'. '6007'} "model object, will be used as argument in #setModelBeforeInitialization:") openWithSpec.
]

{ #category : #initialization }
EchoDebuggerPresenter >> buttonAction_analyzeExecutionButton [
	^ [ echoDebugger analyzeExecution.
		workingExecutionPresenter refreshExecution.
		failingExecutionPresenter refreshExecution.
		self updateDataTable.
	]
]

{ #category : #initialization }
EchoDebuggerPresenter >> buttonAction_inspectEchoDebugger [
	^ [ echoDebugger inspect
	]
]

{ #category : #initialization }
EchoDebuggerPresenter >> buttonAction_stepToNextDivergence [
	^ [ echoDebugger parallelStepUntilDivergence.
		workingExecutionPresenter refreshExecution.
		failingExecutionPresenter refreshExecution.
	]
]

{ #category : #initialization }
EchoDebuggerPresenter >> buttonAction_stepToSenderContext [
	^ [ echoDebugger stepToSenderContext.
		workingExecutionPresenter refreshExecution.
		failingExecutionPresenter refreshExecution.
	]
]

{ #category : #initialization }
EchoDebuggerPresenter >> buttonAction_stepToSenderUntilConvergence [
	^ [ echoDebugger stepToSenderContextUntilConvergence.
		workingExecutionPresenter refreshExecution.
		failingExecutionPresenter refreshExecution.
	]
]

{ #category : #initialization }
EchoDebuggerPresenter >> connectPresenters [

]

{ #category : #initialization }
EchoDebuggerPresenter >> connectPresenters_old [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
	inspectButton action: [ self inspectSelectedItem ].
	executeButton action: [ self inform: 'Todo' ]
]

{ #category : #specs }
EchoDebuggerPresenter >> constraintsOfButtons [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 30 ]
	
]

{ #category : #specs }
EchoDebuggerPresenter >> constraintsOfLabels [
	"Defines a common constraint to be used for all labels"
	^ [ :cstr | cstr height: 20 ]
	
]

{ #category : #initialization }
EchoDebuggerPresenter >> dataTable [
	^ (dataViewer pageAt: 1) activePresenter.
]

{ #category : #specs }
EchoDebuggerPresenter >> defaultSpec_ [

	| echoDebuggingLayout statusViewerHeight |
	statusViewerHeight := 150.
	
	echoDebuggingLayout := (SpBoxLayout newVertical
			add: 'Echo Debugging' withConstraints: self constraintsOfLabels;
			add: (SpBoxLayout newVertical
				"add: 'Status' withConstraints: self constraintsOfLabels;"
				add: #statusViewer withConstraints: [:cstr | cstr height: statusViewerHeight];
				yourself
			) withConstraints: [:cstr | cstr expand: false];
			add: (SpBoxLayout newVertical
				add: 'Operations' withConstraints: self constraintsOfLabels;
				add: #stepToNextDivergenceButton withConstraints: self constraintsOfButtons;
				add: #stepToSenderContextButton withConstraints: self constraintsOfButtons;
				add: #stepToSenderContextUntilConvergenceButton withConstraints: self constraintsOfButtons;
				add: #analyzeExecutionButton withConstraints: self constraintsOfButtons;
				add: #inspectEchoDebuggerButton withConstraints: self constraintsOfButtons;
				yourself	
			) withConstraints: [:cstr | cstr height: 30 * 6];
			add: (SpBoxLayout newVertical
				add: 'Navigation' withConstraints: self constraintsOfLabels;
				add: #dataViewer;
				yourself
			);
			yourself
		).

	^ SpBoxLayout newHorizontal
		add: (SpBoxLayout newHorizontal
			add: (SpBoxLayout newVertical
				add: 'Working Execution' withConstraints: self constraintsOfLabels;
				add: #workingExecutionPresenter;
				yourself);
			add: (SpBoxLayout newVertical
				add: 'Failing Execution' withConstraints: self constraintsOfLabels;
				add: #failingExecutionPresenter;
				yourself);
			yourself
		);
		add: echoDebuggingLayout;
		yourself.
]

{ #category : #specs }
EchoDebuggerPresenter >> defaultSpec_old [

	^ SpBoxLayout newVertical
		add: (SpPanedLayout newHorizontal
			add: #pointTable;
			add: #textField;
			yourself
		);
		add: (SpBoxLayout newHorizontal
			add: #inspectButton withConstraints: self constraintsOfButtons;
			add: #executeButton withConstraints: self constraintsOfButtons;
			yourself	
		) withConstraints: [ :cstr | cstr height: 30 ];
		yourself.
]

{ #category : #initialization }
EchoDebuggerPresenter >> event_receiveDebuggerConnected: informationDictionary [
	| eventSender |
	eventSender := informationDictionary at: #eventSender.
	(eventSender = workingExecutionPresenter) ifTrue: [ echoDebugger proxyClientForWorkingExec: eventSender debuggerProxyClient ].
	(eventSender = failingExecutionPresenter ) ifTrue: [ echoDebugger proxyClientForFailingExec: eventSender debuggerProxyClient ].
	
	echoDebugger isBothDebuggersConnected ifTrue: [ self whenBothDebuggersConnected ].
	
]

{ #category : #initialization }
EchoDebuggerPresenter >> event_receiveStackTableSelectionChanged: informationDictionary [
	self updateStatusTable 
]

{ #category : #icon }
EchoDebuggerPresenter >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ Smalltalk ui icons
]

{ #category : #initialization }
EchoDebuggerPresenter >> initializePresenters [
		
	| statusViewerPageProvider statusViewerPage dataViewerPageProvider dataViewerPage |
	statusViewerPageProvider := [ | statusTable keyColumn valueColumn |
		statusTable := self newTable.
		keyColumn := SpStringTableColumn new.
		keyColumn "title: 'key';"
		evaluation: [ :assoc | assoc key ];
		width: 60.
		valueColumn := SpStringTableColumn new.
		valueColumn "title: 'value';"
		evaluation: [ :assoc | assoc value ].
		statusTable addColumn: keyColumn; addColumn: valueColumn.
		statusTable.	
	].
	statusViewerPage := SpNotebookPage title: 'status' provider: statusViewerPageProvider.
	statusViewer := self newNotebook.
	statusViewer addPage: statusViewerPage.
	
	workingExecutionPresenter := RemoteDebuggerPresenter on: nil.
	workingExecutionPresenter event_subscribeObjectToDebuggerConnectedEvent: self.
	workingExecutionPresenter event_subscribeObjectToStackTableSelectionChangedEvent: self.
	initialPortWorkingExecution ifNotNil: [:port |
		workingExecutionPresenter whenDisplayDo: [:e | e presenter connectToDebuggerServerOnPort: port ]].
	
	failingExecutionPresenter := RemoteDebuggerPresenter on: nil.
	failingExecutionPresenter event_subscribeObjectToDebuggerConnectedEvent: self.
	failingExecutionPresenter event_subscribeObjectToStackTableSelectionChangedEvent: self.
	initialPortFailingExecution  ifNotNil: [:port |
		failingExecutionPresenter whenDisplayDo: [:e | e presenter connectToDebuggerServerOnPort: port ]].
	
	stepToNextDivergenceButton := self newButton.
	stepToNextDivergenceButton label: 'Step to next divergence';
	action: self buttonAction_stepToNextDivergence.
	
	stepToSenderContextButton := self newButton.
	stepToSenderContextButton label: 'Step to sender context';
	action: self buttonAction_stepToSenderContext.
	
	analyzeExecutionButton := self newButton.
	analyzeExecutionButton label: 'Analyze execution';
	action: self buttonAction_analyzeExecutionButton.
	
	stepToSenderContextUntilConvergenceButton := self newButton.
	stepToSenderContextUntilConvergenceButton label: 'Step to sender until convergence';
	action: self buttonAction_stepToSenderUntilConvergence.
	
	inspectEchoDebuggerButton := self newButton.
	inspectEchoDebuggerButton label: 'Inspect Echo Debugger';
	action: self buttonAction_inspectEchoDebugger.
	
	statusViewerPageProvider := [ | statusTable keyColumn valueColumn |
		statusTable := self newTable.
		keyColumn := SpStringTableColumn new.
		keyColumn "title: 'key';"
		evaluation: [ :assoc | assoc key ];
		width: 60.
		valueColumn := SpStringTableColumn new.
		valueColumn "title: 'value';"
		evaluation: [ :assoc | assoc value ].
		statusTable addColumn: keyColumn; addColumn: valueColumn.
		statusTable.	
	].
	statusViewerPage := SpNotebookPage title: 'status' provider: statusViewerPageProvider.
	statusViewer := self newNotebook.
	statusViewer addPage: statusViewerPage.


	dataViewerPageProvider := [ |dataTable natureColumn indexWorkingColumn indexFailingColumn|
		dataTable := self newTable.
		natureColumn := SpStringTableColumn new.
		natureColumn title: 'Nature';
		evaluation: [ :event | event nature ].
		indexWorkingColumn := SpStringTableColumn new.
		indexWorkingColumn title: 'W Step Index';
		evaluation: [ :event | event index_working ].
		indexFailingColumn := SpStringTableColumn new.
		indexFailingColumn title: 'F Step Index';
		evaluation: [ :event | event index_failing ].
		
		dataTable addColumn: natureColumn;
		addColumn: indexWorkingColumn;
		addColumn: indexFailingColumn.
		dataTable items: echoDebugger data
	].
	dataViewerPage := SpNotebookPage title: 'data' provider: dataViewerPageProvider.
	dataViewer := self newNotebook.
	dataViewer addPage: dataViewerPage.
]

{ #category : #initialization }
EchoDebuggerPresenter >> initializePresenters_old [
	"The method initializePresenters instantiates, saves in instance vari- ables, and partially configures the different widgets that will be part of the UI.
	In general the initializePresenters method should follow the pattern:
		• widget instantiation
		• widget configuration specification
		• specification of focus order"
		
	| indexColumn xColumn yColumn |
	pointTable := self newTable. "SpTablePresenter"
	indexColumn := SpIndexTableColumn new width: 40; title: 'Index'; yourself.
	xColumn := SpStringTableColumn new evaluated: [:item | item x]; title: 'X'; width: 60; yourself.
	yColumn := SpStringTableColumn new evaluated: [:item | item y]; title: 'Y'; width: 60; yourself.
	pointTable addColumn: indexColumn; addColumn: xColumn; addColumn: yColumn.
	pointTable items: self collectionOfPoints.
		
	textField := self newText. "SpTextPresenter"
	textField placeholder: 'placeholder text'; autoAccept: true. "You cans et something to happen when the user 'accepts' the code (ctrl-s, like to save a method)"
	
	"These two buttons get their actions assigned in #connectPresenters"
	inspectButton := self newButton. "SpButtonPresenter"
	inspectButton label: 'Inspect Selected'; icon: (self iconManager iconNamed: #glamorousInspect).
	
	executeButton := self newButton. "SpButtonPresenter"
	executeButton label: 'Execute'; icon: (self iconManager iconNamed: #glamorousGo).
	
	"I don't know how to do focus order"
]

{ #category : #initialization }
EchoDebuggerPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'EchoDebugger';
		initialExtent: 1300@800; "initial width@height of the window"
		windowIcon: (self iconManager iconNamed: #home) "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #initialization }
EchoDebuggerPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	echoDebugger := EchoDebugger new.
	initialPortWorkingExecution := anObject at: 1.
	initialPortFailingExecution := anObject at: 2.
]

{ #category : #initialization }
EchoDebuggerPresenter >> statusTable [
	^ (statusViewer pageAt: 1) activePresenter.
]

{ #category : #initialization }
EchoDebuggerPresenter >> updateDataTable [
	echoDebugger isBothDebuggersConnected ifFalse: [^self].
	self dataTable items: echoDebugger data.
]

{ #category : #initialization }
EchoDebuggerPresenter >> updateStatusTable [
	| items |
	echoDebugger isBothDebuggersConnected ifFalse: [^self].
	items := Dictionary new.
	items at: #'Node =?' put: workingExecutionPresenter selectedNode = failingExecutionPresenter selectedNode.
	items at: #'Context =?' put: workingExecutionPresenter selectedContext = failingExecutionPresenter selectedContext.
	self statusTable items: items associations.
]

{ #category : #initialization }
EchoDebuggerPresenter >> whenBothDebuggersConnected [
	self updateStatusTable.
]
