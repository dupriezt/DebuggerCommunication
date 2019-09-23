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
	server := SindarinDebuggerServer newOnSindarinDebugger: (SindarinDebugger debug: [Point new. Point x:1 y: 2]).
	server startListeningOnPort: 1234.
	client := SindarinDebuggerClient new.
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
	self assert:( server handleRequest: (SindarinCommand new command: #currentNode ; serialized)) selector equals: #new.
]
