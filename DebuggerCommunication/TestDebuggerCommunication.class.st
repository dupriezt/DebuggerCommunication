Class {
	#name : #TestDebuggerCommunication,
	#superclass : #TestCase,
	#instVars : [
		'server',
		'client'
	],
	#category : #DebuggerCommunication
}

{ #category : #running }
TestDebuggerCommunication >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	server := DebuggerServerForTest new.
	server startListeningOnPort: 1234.
	client := DebuggerClient new.
]

{ #category : #running }
TestDebuggerCommunication >> tearDown [ 
	"Hooks that subclasses may override to define the fixture of test."
	server stop
]

{ #category : #running }
TestDebuggerCommunication >> testManualSendStepping [
	self assert:( server handleRequest: (SteppingCommand new command: #stepInto ; serialized)) equals: #stepInto.
]

{ #category : #running }
TestDebuggerCommunication >> testSendStepping [
	| res |
	res :=client sendStepInCommand.
	self assert: res equals: #stepInto.
]
