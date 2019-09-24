Class {
	#name : #TestSindarinDebuggerCommunication,
	#superclass : #TestCase,
	#instVars : [
		'server',
		'client'
	],
	#category : #DebuggerCommunication
}

{ #category : #running }
TestSindarinDebuggerCommunication >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	| port |
	SindarinDebuggerServer stopAll. "Stop all existing SindarinDebuggerServer to prevent them from interfering with the tests".
	port := 1234.
	server := SindarinDebuggerServer newOnSindarinDebugger: (SindarinDebugger debug: [Point new. Point x:1 y: 2]).
	server startListeningOnPort: port.
	client := SindarinDebuggerClient newOnPort: port.
]

{ #category : #running }
TestSindarinDebuggerCommunication >> tearDown [ 
	"Hooks that subclasses may override to define the fixture of test."
	server stop
]

{ #category : #running }
TestSindarinDebuggerCommunication >> testCurrentNodeAndStepOver [
	| res |
	res := client send: #currentNode.
	self assert: res isMessage.
	self assert: res selector equals: #new.
	client send: #stepOver.
	res := client send: #currentNode.
	self assert: res isMessage.
	self assert: res selector equals: #x:y:.
]

{ #category : #running }
TestSindarinDebuggerCommunication >> testManualSendCurrentNode [
	self assert:( server handleRequest: (SindarinRequest new command: #currentNode ; serialized)) selector equals: #new.
]
