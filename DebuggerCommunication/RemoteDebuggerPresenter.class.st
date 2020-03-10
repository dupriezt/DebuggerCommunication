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
		'debuggerProxyClient'
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

{ #category : #data }
RemoteDebuggerPresenter >> collectionOfPoints [
	| c |
	c := OrderedCollection new.
	c add: (Point x: 1 y: 5).
	c add: (Point x: 48 y: 1).
	c add: (Point x: 5 y: 6).
	c add: (Point x: 1 y: 48).
	c add: (Point x: 3 y: 92).
	c add: (Point x: 4 y: 67).
	c add: (Point x: 8 y: 5).
	c add: (Point x: 16 y: 22).
	c add: (Point x: 22 y: 21).
	c add: (Point x: 2 y: 31).
	c add: (Point x: 43 y: 2).
	^ c
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
RemoteDebuggerPresenter >> connectToDebuggerServerOnPort: anInteger [
	debuggerClient := SindarinDebuggerClient newOnPort: anInteger.
	debuggerProxyClient := SindarinDebuggerProxyClient newOnSindarinDebuggerClient: debuggerClient.
]

{ #category : #specs }
RemoteDebuggerPresenter >> constraintsOfButtons [
	"Defines a common constraint to be used for all buttons"
	^ [ :cstr | cstr width: 120. cstr height: 20 ]
	
]

{ #category : #specs }
RemoteDebuggerPresenter >> constraintsOfLabels [
	"Defines a common constraint to be used for all labels"
	^ [ :cstr | cstr height: 20 ]
]

{ #category : #specs }
RemoteDebuggerPresenter >> defaultSpec_ [
	| connectionBoxLayout |

	connectionBoxLayout := SpBoxLayout newVertical
		add: 'port' withConstraints: self constraintsOfLabels;
		add: #portField;
		"add: #connectButtons withConstraints: self constraintsOfButtons;"
		yourself.

	^ SpBoxLayout newVertical
		add: connectionBoxLayout;
		add: #stack;
		add: #contextInspector;
		add: #nodeViewer;
		yourself
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
	portField := self newNumberInput.
	portField whenTextIsAcceptedDo: [:port | self connectToDebuggerServerOnPort: port ].
	"connectButtons := self newButton."
	
	
	stack := self newText.
	stack text: 'stack'.
	
	contextInspector := self newText.
	contextInspector text: 'Context inspector'.
	
	nodeViewer := self newText.
	nodeViewer text: 'Node viewer'.
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
		windowIcon: (self iconManager iconNamed: #home) "Icon that will be shown in the bottom windowbar for this window"
]

{ #category : #'button action' }
RemoteDebuggerPresenter >> inspectSelectedItem [
	pointTable selectedItems inspect.
]

{ #category : #initialization }
RemoteDebuggerPresenter >> setModelBeforeInitialization: anObject [
	"This method is called before the initialisation methods (like #initializePresenters), when this presenter instance is created by sending #on: to its class. It is typically used to fill the instance variables of this presenter instance before the initilisation methods get called.
	@anObject is the argument provided to the #on: call. It typically contains all the values to be put into the instance variables"
	
	"instanceVariable1 := anObject getValueForInstanceVariable1"
]
