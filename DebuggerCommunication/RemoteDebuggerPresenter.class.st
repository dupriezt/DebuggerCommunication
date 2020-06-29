Class {
	#name : #RemoteDebuggerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'pointTable',
		'textField',
		'executeButton',
		'inspectButton',
		'stack',
		'contextInspector',
		'nodeViewer',
		'portField',
		'connectButtons',
		'debuggerClient',
		'debuggerProxyClient',
		'refreshButton',
		'subscribersToDebuggerConnectedEvent',
		'subscribersToStackTableSelectionChangedEvent',
		'nodeRepresentation',
		'restartButton',
		'connectButton'
	],
	#category : #DebuggerCommunication
}

{ #category : #specs }
RemoteDebuggerPresenter class >> defaultSpec [
	"Definition of the layout moved to the instance side, for easier editing (no need to switch between the instance and class side in the code browser"
	^ self basicNew defaultSpec_
]

{ #category : #specs }
RemoteDebuggerPresenter class >> open [
	<script>
	(self on: nil "model object, will be used as argument in #setModelBeforeInitialization:") openWithSpec.
]

{ #category : #initialization }
RemoteDebuggerPresenter >> buttonAction_inspect [
	| dict |
	^ [
		dict := Dictionary new.
		dict at: #debuggerClient put: debuggerClient.
		dict at: #debuggerProxyClient put: debuggerProxyClient.
		dict at: #stack put: self stackTable items.
		dict at: #context put: (self stackTable selectedItems ifEmpty: [ nil ] ifNotEmpty: [ :array | array at: 1 ]).
		dict at: #node put: nodeRepresentation.
		dict inspect
	]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> buttonAction_refresh [
	^ [ self refreshExecution ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> buttonAction_restart [
	^ [
		self restartExecution	
	]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> connectPresenters [
	
]

{ #category : #initialization }
RemoteDebuggerPresenter >> connectPresenters_old [
	"The method connectPresenters defines the interactions between the dif- ferent widgets. By connecting the behaviors of the different widgets it speci- fies the overall presentation, i.e., how the overall UI responds to interactions by the user. Usually this method consists of specifications of actions to per- form when a certain event is received by a widget. The whole interaction flow of the UI then emerges from the propagation of those events."
	inspectButton action: [ self inspectSelectedItem ].
	executeButton action: [ self inform: 'Todo' ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> connectToDebuggerServerOnPort: aString [
	portField text: aString.
	debuggerClient := SindarinDebuggerClient newOnPort: aString.
	debuggerProxyClient := SindarinDebuggerProxyClient newOnSindarinDebuggerClient: debuggerClient.
	[(debuggerClient ping) ifTrue: [
		self inform: 'Connected on port ', aString.
		self refreshExecution.
		self event_sendDebuggerConnectedEvent.
	]] on: ConnectionTimedOut do: [self inform: 'Cannot connect to port ', aString].

	
]

{ #category : #specs }
RemoteDebuggerPresenter >> constraintsOfButtons [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 30 ]
	
]

{ #category : #specs }
RemoteDebuggerPresenter >> constraintsOfLabels [
	"Defines a common constraint to be used for all labels"
	^ [ :cstr | cstr height: 20 ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> contextTable [
	^ (contextInspector pageAt: 1) activePresenter
]

{ #category : #accessing }
RemoteDebuggerPresenter >> debuggerClient [
	^ debuggerClient
]

{ #category : #accessing }
RemoteDebuggerPresenter >> debuggerProxyClient [
	^ debuggerProxyClient
]

{ #category : #specs }
RemoteDebuggerPresenter >> defaultSpec_ [
	| connectionBoxLayout |

	connectionBoxLayout := SpBoxLayout newVertical
		add: 'port' withConstraints: self constraintsOfLabels;
		add: (SpBoxLayout newHorizontal
			add: #portField;
			add: #connectButton expand: false;
			yourself
		);
		"add: #connectButtons withConstraints: self constraintsOfButtons;"
		yourself.

	^ SpBoxLayout newVertical
		add: connectionBoxLayout withConstraints: [:cstr | cstr height: 50];
		add: (SpBoxLayout newVertical
			add: #inspectButton withConstraints: self constraintsOfButtons;
			add: #refreshButton withConstraints: self constraintsOfButtons;
			"add: #restartButton withConstraints: self constraintsOfButtons;"
			yourself
		) withConstraints: [:cstr | cstr height: 2 * 30];
		"add: (SpBoxLayout newVertical
			add: (SpGridLayout new
				add: #inspectButton at: 1@1;
				add: #refreshButton at: 2@1;
				borderWidth: 0;
				columnSpacing: 5;
				yourself 
			) withConstraints: [:cstr | cstr height: 30. cstr expand: false. cstr fill: false];
			yourself);"
		"add: (SpBoxLayout newHorizontal
			add: (SpBoxLayout newVertical
				add: #inspectButton withConstraints: self constraintsOfButtons;
				yourself);
			add: (SpBoxLayout newVertical
				add: #refreshButton withConstraints: self constraintsOfButtons;
				yourself);
			yourself);"
		add: #stack;
		add: #contextInspector;
		add: #nodeViewer;
		yourself
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_sendDebuggerConnectedEvent [
	| information |
	information := Dictionary new.
	information at: #eventSender put: self.
	subscribersToDebuggerConnectedEvent do: [ :subscriber | subscriber event_receiveDebuggerConnected: information ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_sendStackTableSelectionChangedEvent [
	| information |
	information := Dictionary new.
	information at: #eventSender put: self.
	information at: #selectedItem put: self selectedContext.
	subscribersToStackTableSelectionChangedEvent do: [ :subscriber | subscriber event_receiveStackTableSelectionChanged: information ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_subscribeObjectToDebuggerConnectedEvent: anObject [
	subscribersToDebuggerConnectedEvent add: anObject
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_subscribeObjectToStackTableSelectionChangedEvent: anObject [
	subscribersToStackTableSelectionChangedEvent add: anObject
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_unsubscribeObjectToDebuggerConnectedEvent: anObject [
	subscribersToDebuggerConnectedEvent remove: anObject
]

{ #category : #initialization }
RemoteDebuggerPresenter >> event_unsubscribeObjectToStackTableSelectionChangedEvent: anObject [
	subscribersToStackTableSelectionChangedEvent remove: anObject
]

{ #category : #'button action' }
RemoteDebuggerPresenter >> executeCode [
]

{ #category : #icon }
RemoteDebuggerPresenter >> iconManager [
	"This is where this application gets its icons.
	To see the list of available icons, inspect 'Smalltalk ui icons' and click on the 'Icons' tab"
	^ Smalltalk ui icons
]

{ #category : #initialization }
RemoteDebuggerPresenter >> initializePresenters [
	| stackPresenterProvider stackPage contextPresenterProvider contextPage nodeViewerCodePageProvider nodeViewerCodePage nodeViewerRawPageProvider nodeViewerRawPage |
	portField := self newNumberInput.
	"portField whenNumberChangedDo: [:port | self connectToDebuggerServerOnPort: port ]."
	"connectButtons := self newButton."
	
	connectButton := self newButton.
	connectButton label: 'Connect';
	action: [self connectToDebuggerServerOnPort: portField text].
	
	inspectButton := self newButton.
	inspectButton label: 'Inspect';
	action: self buttonAction_inspect.
		
	refreshButton := self newButton.
	refreshButton label: 'Refresh';
	action: self buttonAction_refresh.	
		
	restartButton := self newButton.
	restartButton label: 'Restart';
	action: self buttonAction_restart.
		
	stackPresenterProvider := [ |stackTable classColumn selectorColumn|
		stackTable := self newTable.
		classColumn := SpStringTableColumn new.
		classColumn title: 'Class';
		evaluation: [ :context | context at: #class ].
		selectorColumn := SpStringTableColumn new.
		selectorColumn title: 'Selector';
		evaluation: [ :context | context at: #selector ].
		stackTable addColumn: classColumn.
		stackTable addColumn: selectorColumn.
		
		stackTable whenSelectionChangedDo: self stackTableSelectionChangedBlock.
		stackTable.
	].
	stackPage := SpNotebookPage title: 'stack' provider: stackPresenterProvider.
	stack := self newNotebook.
	stack addPage: stackPage.
	
	contextPresenterProvider := [ | contextTable keyColumn valueColumn|
		contextTable := self newTable.
		keyColumn := SpStringTableColumn new.
		keyColumn title: 'key';
		evaluation: [ :assoc | assoc key ];
		width: 60.
		valueColumn := SpStringTableColumn new.
		valueColumn title: 'value';
		evaluation: [ :assoc | assoc value ].
		contextTable addColumn: keyColumn; addColumn: valueColumn.
		contextTable.	
	].
	contextPage := SpNotebookPage title: 'context' provider: contextPresenterProvider.
	contextInspector := self newNotebook.
	contextInspector addPage: contextPage.

	nodeViewerRawPageProvider := [ | nodeViewerRawTable keyColumn valueColumn|
		nodeViewerRawTable := self newTable.
		keyColumn := SpStringTableColumn new.
		keyColumn title: 'key';
		evaluation: [ :assoc | assoc key ];
		width: 90.
		valueColumn := SpStringTableColumn new.
		valueColumn title: 'value';
		evaluation: [ :assoc | assoc value ].
		nodeViewerRawTable addColumn: keyColumn; addColumn: valueColumn.
		nodeRepresentation ifNotNil: [ :node_ | nodeViewerRawTable items: node_ associations ].
		nodeViewerRawTable.
	].
	nodeViewerCodePageProvider := [ | nodeViewerCodePresenter |
		nodeViewerCodePresenter := self newCode.
		nodeViewerCodePresenter withSyntaxHighlight; autoAccept: true.
		nodeViewerCodePresenter.
	].
	nodeViewerCodePage := SpNotebookPage title: 'node (code)' provider: nodeViewerCodePageProvider.
	nodeViewerRawPage := SpNotebookPage title: 'node (raw)' provider: nodeViewerRawPageProvider.
	nodeViewer := self newNotebook.
	nodeViewer addPage: nodeViewerCodePage.
	nodeViewer addPage: nodeViewerRawPage.

]

{ #category : #initialization }
RemoteDebuggerPresenter >> initializePresenters_old [
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
RemoteDebuggerPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'EchoDebugger';
		initialExtent: 500@280; "initial width@height of the window"
		windowIcon: (self iconManager iconNamed: #home). "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #initialization }
RemoteDebuggerPresenter >> nodeViewerCodePresenter [
	^ (nodeViewer pageAt: 1) activePresenter
]

{ #category : #initialization }
RemoteDebuggerPresenter >> nodeViewerRawTable [
	^ (nodeViewer pageAt: 2) activePresenter
]

{ #category : #initialization }
RemoteDebuggerPresenter >> refreshExecution [
	self stackTable items: debuggerProxyClient stack.
	self stackTable selectIndex: 1.
]

{ #category : #initialization }
RemoteDebuggerPresenter >> restartExecution [
	debuggerProxyClient restart.
	self refreshExecution.
]

{ #category : #initialization }
RemoteDebuggerPresenter >> selectedContext [
	^ self stackTable selectedItems ifEmpty: [ nil ] ifNotEmpty: [ :array | array at: 1 ]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> selectedNode [
	^ self stackTable selectedItems ifEmpty: [ nil ] ifNotEmpty: [ :array | (array at: 1) at: #node]
]

{ #category : #initialization }
RemoteDebuggerPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	"instanceVariable1 := anObject getValueForInstanceVariable1"
	subscribersToDebuggerConnectedEvent := OrderedCollection new.
	subscribersToStackTableSelectionChangedEvent := OrderedCollection new.
]

{ #category : #initialization }
RemoteDebuggerPresenter >> stackTable [
	^ (stack pageAt: 1) activePresenter
]

{ #category : #initialization }
RemoteDebuggerPresenter >> stackTableSelectionChangedBlock [
	| selectedContext |
	^ [ :newSelection |
		newSelection selectedIndex ~= 0 ifTrue: [
			selectedContext := self stackTable items at: newSelection selectedIndex.
			self contextTable items: selectedContext associations.
			nodeRepresentation := selectedContext at: #node.
			(self nodeViewerRawTable) ifNotNil: [:nodeViewerRawTable | nodeViewerRawTable items: (selectedContext at: #node) associations].
			self nodeViewerCodePresenter text: (nodeRepresentation at: #methodSourceCode).
			self nodeViewerCodePresenter behavior: (SmalltalkImage current classNamed: (selectedContext at: #class)).
			self nodeViewerCodePresenter selectionInterval: ((nodeRepresentation at: #start) to: (nodeRepresentation at: #stop)).
			self event_sendStackTableSelectionChangedEvent.
		]
	]
]
