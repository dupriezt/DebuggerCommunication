"
I am a copy of class SindarinDebuggerClient. This comment is copied from there, and might not be entirely accurate

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	port:		<Object>


    Implementation Points
"
Class {
	#name : #'SindarinDebuggerClient_NoCommandSerialisation',
	#superclass : #Object,
	#instVars : [
		'port'
	],
	#category : #DebuggerCommunication
}

{ #category : #'instance creation' }
SindarinDebuggerClient_NoCommandSerialisation class >> newOnPort: anInteger [
"example: anInteger = 1234"
	^ self new newOnPort: anInteger 
]

{ #category : #'instance creation' }
SindarinDebuggerClient_NoCommandSerialisation >> newOnPort: anInteger [
	"Example: anInteger = 1234"
	port := anInteger.
	^ self
]

{ #category : #communication }
SindarinDebuggerClient_NoCommandSerialisation >> step [
	"#s for step"
	| client |
	client := ZnClient new.
	client
		url: 'http://localhost:', port asString;
		entity: (ZnEntity bytes: #s asByteArray);
		post.
]

{ #category : #communication }
SindarinDebuggerClient_NoCommandSerialisation >> stepOver [
	"#o for stepOver"
	| client |
	client := ZnClient new.
	client
		url: 'http://localhost:', port asString;
		entity: (ZnEntity bytes: #o asByteArray);
		post.
]
