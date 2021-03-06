Class {
	#name : #SpAbstractTextPresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'#hasUnacceptedEdits => SpObservableSlot',
		'#selection => SpObservableSlot',
		'#autoAccept => SpObservableSlot',
		'#wantsVisualFeedback => SpObservableSlot',
		'#askBeforeDiscardingEdits => SpObservableSlot',
		'#contextMenu => SpObservableSlot',
		'#text => SpObservableSlot',
		'#actionToPerform => SpObservableSlot',
		'#readSelection => SpObservableSlot',
		'#actionPerformed => SpObservableSlot'
	],
	#category : #'Spec2-Core-Widgets'
}

{ #category : #api }
SpAbstractTextPresenter >> accept [
	"Accep the current pendingtext"

	self changed: #accept with: #().

	"Raise an announcement"
	self actionPerformed
]

{ #category : #api }
SpAbstractTextPresenter >> accept: aText notifying: aNotifyier [
	| accept |
	accept := self acceptBlock cull: aText cull: aNotifyier.
	accept == false ifTrue: [ ^ false ].

	self text: aText copy.

	"Raise an announcement"
	self actionPerformed.

	self changed: #clearUserEdits.
	^ true
]

{ #category : #api }
SpAbstractTextPresenter >> acceptBlock [
	"Return the block to perform when the text is accepted.
	The block must have one argument, which will be the accepted text"

	^ actionToPerform
]

{ #category : #api }
SpAbstractTextPresenter >> acceptBlock: aBlockWithOneArgument [
	"Set the block to perform when the text is accepted.
	The block must have one argument, which will be the accepted text.
	The block can return false if the candidate text is to be rejected"

	actionToPerform := aBlockWithOneArgument
]

{ #category : #private }
SpAbstractTextPresenter >> acceptText: aString [
	"Used to set the text value comming from the adapter (we do not want to re-send 
	 this value to the adapter, hence we set it 'raw', not triggering events)"

	self property: #text rawValue: aString
]

{ #category : #private }
SpAbstractTextPresenter >> actionPerformed [
	actionPerformed := self text
]

{ #category : #api }
SpAbstractTextPresenter >> askBeforeDiscardingEdits [
	^ askBeforeDiscardingEdits
]

{ #category : #api }
SpAbstractTextPresenter >> askBeforeDiscardingEdits: aBoolean [
	askBeforeDiscardingEdits := aBoolean
]

{ #category : #api }
SpAbstractTextPresenter >> autoAccept [
	"Return true if the text is accepted after ech keystroke"

	^ autoAccept
]

{ #category : #api }
SpAbstractTextPresenter >> autoAccept: aBoolean [
	"Set if the text is accepted after each keystroke or not"

	autoAccept := aBoolean
]

{ #category : #api }
SpAbstractTextPresenter >> clearSelection [
"	<api: #do>"
   "Remove selection from the text model"

	self setSelection: (0 to: 0)
]

{ #category : #'undo-redo' }
SpAbstractTextPresenter >> clearUndoManager [

	self withAdapterDo: #clearUndoManager
]

{ #category : #api }
SpAbstractTextPresenter >> contextMenu [

	^ contextMenu
]

{ #category : #api }
SpAbstractTextPresenter >> contextMenu: aValuable [

	contextMenu := aValuable
]

{ #category : #api }
SpAbstractTextPresenter >> enabled: aBoolean [

	super enabled: aBoolean.
	self 
		changed: #enabled: 
		with: { aBoolean }
]

{ #category : #focus }
SpAbstractTextPresenter >> eventKeyStrokesForNextFocus [
	"String describing the keystroke to perform to jump to the next widget"
	^ { Character arrowRight command ctrl asKeyCombination }
]

{ #category : #focus }
SpAbstractTextPresenter >> eventKeyStrokesForPreviousFocus [
	"String describing the keystroke to perform to jump to the previous widget"

	^ { Character arrowLeft command ctrl asKeyCombination }
]

{ #category : #private }
SpAbstractTextPresenter >> getMenu [
	self flag: #TODO.	"move to menu presenters"
	^ (PragmaMenuBuilder
		pragmaKeyword: self textArea editingModeClass menuKeyword
		model: self adapter) menu
]

{ #category : #api }
SpAbstractTextPresenter >> getSelection [
	"Get the text selection"

	^ selection ifNil: [ ^ 1 to: 0 ]
]

{ #category : #api }
SpAbstractTextPresenter >> hasEditingConflicts [
	"<api:#inspect>"
	"Return if the text zone has editing conflicts"

	^ self widget 
		ifNil: [ false ]
		ifNotNil: [:w | w hasEditingConflicts ]
]

{ #category : #api }
SpAbstractTextPresenter >> hasEditingConflicts: aBoolean [
	"Set if the text zone has editing conflicts"
	"<api:#boolean getter: #hasEditingConflicts>"
	
	^ self changed: #hasEditingConflicts: with: { aBoolean }
]

{ #category : #api }
SpAbstractTextPresenter >> hasUnacceptedEdits [
	"Return if the text zone has unaccepted edits (orange corner)"

	^ hasUnacceptedEdits
]

{ #category : #api }
SpAbstractTextPresenter >> hasUnacceptedEdits: aBoolean [
	"Return if the text zone has unaccepted edits (orange corner)"

	hasUnacceptedEdits := aBoolean
]

{ #category : #initialization }
SpAbstractTextPresenter >> initialize [
	super initialize.

	text := ''.
	actionToPerform := [ :txt |  ].
	readSelection := [ selection ].
	actionPerformed := ''.
	hasUnacceptedEdits := false.
	selection := 1 to: 0.
	autoAccept := false.
	wantsVisualFeedback := true.
	askBeforeDiscardingEdits := true.

	self registerEvents
]

{ #category : #api }
SpAbstractTextPresenter >> isForSmalltalkCode [

	"self 
		deprecated: 'The forCode functionality has moved to TextCodePresenter, please use it instead TextPresenter.' 
		on: '2019-04-05' 
		in: #Pharo8"

	^ false
]

{ #category : #api }
SpAbstractTextPresenter >> isForSmalltalkCode: aBoolean [
	
	"self 
		deprecated: 'The forCode functionality has moved to TextCodePresenter, please use it instead TextPresenter.' 
		on: '2019-04-05' 
		in: #Pharo8"
]

{ #category : #'api-errors' }
SpAbstractTextPresenter >> notify: errorMessage at: position in: sourceCode [

	self changed: #notify:at:in: with: { errorMessage . position . sourceCode }
]

{ #category : #api }
SpAbstractTextPresenter >> readSelection [
	^ self readSelectionBlock cull: self text cull: self
]

{ #category : #api }
SpAbstractTextPresenter >> readSelectionBlock [
	"Return the block used to calculate the text selection"

	^ readSelection
]

{ #category : #api }
SpAbstractTextPresenter >> readSelectionBlock: aBlock [
	"Set the block used to calculate the text selection"

	^ readSelection := aBlock
]

{ #category : #initialization }
SpAbstractTextPresenter >> registerEvents [
	self whenTextChangedDo: [ self changed: #getText ].
	self whenReadSelectionIsChangedDo: [ self changed: #readSelection ].
	self property: #hasUnacceptedEdits whenChangedDo: [ :bool | self changed: #setHasUnacceptedEdits: with: {bool} ].
	self property: #selection whenChangedDo: [ :block | self changed: #setSelectionFromModel: with: {block value} ].
	self whenAutoAcceptChangedDo: [ :bool | self changed: #autoAccept: with: {bool} ].
	self property: #wantsVisualFeedback whenChangedDo: [ :bool | self changed: #changed with: #() ].
	self property: #askBeforeDiscardingEdits whenChangedDo: [ :bool | self changed: #askBeforeDiscardingEdits: with: {bool} ]
]

{ #category : #api }
SpAbstractTextPresenter >> selectAll [
	
	self changed: #selectAll with: #()
]

{ #category : #NOCompletion }
SpAbstractTextPresenter >> selectedClassOrMetaClass [

	^ self behavior
]

{ #category : #api }
SpAbstractTextPresenter >> setSelection: anInterval [
	"Set the text selection without changing the readSelectionBlock"

	selection := anInterval
]

{ #category : #api }
SpAbstractTextPresenter >> setSelectionInterval: anInterval [
	self property: #selection rawValue: anInterval
]

{ #category : #api }
SpAbstractTextPresenter >> text [
	^ text
]

{ #category : #api }
SpAbstractTextPresenter >> text: aText [
	"Set the text of the text zone"

	text := aText
]

{ #category : #private }
SpAbstractTextPresenter >> textArea [
	^ self adapter widget
]

{ #category : #simulating }
SpAbstractTextPresenter >> type: aString [ 
	"For simulation: Do as if we type the given string"
	self text: aString
]

{ #category : #api }
SpAbstractTextPresenter >> wantsVisualFeedback [
	^ wantsVisualFeedback
]

{ #category : #api }
SpAbstractTextPresenter >> wantsVisualFeedback: aBoolean [
	wantsVisualFeedback := aBoolean
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenAboutToStyleChangedDo: aBlock [
	"<api: #event>"
	"Set a block to perform when the about to style block changed"
	
	self whenAboutToStyleBlockChanged: [:block :old :announcement :anAnnouncer | 
		aBlock cull: (block value) cull: old cull: announcement cull: anAnnouncer ]
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenAcceptBlockChangedDo: aBlock [
	"Set a block to perform when the accept block changed"
	
	self property: #actionToPerform whenChangedDo: aBlock
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenAutoAcceptChangedDo: aBlock [
	"aBlock will be performed when autoAccept changed"

	self property: #autoAccept whenChangedDo: aBlock
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenMenuChangedDo: aBlock [
	"Set a block to value when the menu block has changed"
	
	self property: #contextMenu whenChangedDo: aBlock
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenReadSelectionIsChangedDo: aBlock [
	"Set a block to perform when the read selection block changed"

	self property: #readSelection whenChangedDo: aBlock
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenTextChangedDo: aBlock [
	"Set a block to perform when the text changed"

	self property: #text whenChangedDo: aBlock
]

{ #category : #'api-events' }
SpAbstractTextPresenter >> whenTextIsAcceptedDo: aBlock [
	"Set a block to perform when the text is accepted"
	
	self property: #actionPerformed whenChangedDo: aBlock
]
