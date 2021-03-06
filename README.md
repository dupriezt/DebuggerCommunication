# DebuggerCommunication

## Installation
```smalltalk
Metacello new
    baseline: 'DebuggerCommunication';
    repository: 'github://dupriezt/DebuggerCommunication';
    load.
```
## Usage
Code in server image (where the debugged execution actually runs):
```smalltalk
dbg := SindarinDebugger debug: [ "Code to be debugged" ].
dbgServer := SindarinDebuggerServer newOnSindarinDebugger: dbg.
dbgServer startListeningOnPort: 1123.
```

Code in the client image (which remotely controls the debugger in the server image):
```smalltalk
dbgp1 := SindarinDebuggerProxyClient newOnSindarinDebuggerClient: (SindarinDebuggerClient newOnPort: 1123).
```

Then you can send messages to `dbgp1` in the client image, as if you were sending them to the sindarin debugger running in the server image.

To stop a server:
```smalltalk
dbgServer stop
```
