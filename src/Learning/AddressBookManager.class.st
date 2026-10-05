"
adress book class
"
Class {
	#name : 'AddressBookManager',
	#superclass : 'Object',
	#instVars : [
		'addressBook'
	],
	#category : 'Learning',
	#package : 'Learning'
}

{ #category : 'initialization' }
AddressBookManager >> add: el [
	"Додавання масиву запису до адресної книги"
	addressBook add: el.
]

{ #category : 'initialization' }
AddressBookManager >> addWithUIManager [
	"Додавання нового запису через вікна діалогу з покращеною перевіркою"
	| a b c | 
	a := UIManager default request: 'Input first name (Ім''я)'.
	b := UIManager default request: 'Input second name (Прізвище)'.
	c := UIManager default request: 'Input address (Адреса)'.
	
	"Використовуємо isEmptyOrNil, бо порожній ввід повертає '', а Cancel повертає nil"
	(a isEmptyOrNil or: [ b isEmptyOrNil or: [ c isEmptyOrNil ] ]) 
		ifFalse: [ 
			addressBook add: (Array with: b with: a with: c).
			UIManager default inform: 'Запис успішно додано!'.
		]
		ifTrue: [
			UIManager default inform: 'Додавання скасовано: одне з полів порожнє.'.
		].
]

{ #category : 'printing' }
AddressBookManager >> countPeopleWithLongNames [
	"ВЛАСНИЙ ВАРІАНТ 3: Використання count: 
	 Підраховує кількість людей, чиє ім'я (другий елемент) містить більше 5 символів"
	| count |
	count := addressBook count: [ :entry | (entry at: 2) size > 5 ].
	^ count
]

{ #category : 'printing' }
AddressBookManager >> extractAllUniqueAddresses [
	"ВЛАСНИЙ ВАРІАНТ 2: Використання collect: та asSet 
	 Збирає всі адреси з книги, а потім видаляє дублікати (якщо кілька людей живуть за однією адресою)"
	| allAddresses uniqueAddresses |
	allAddresses := addressBook collect: [ :entry | entry at: 3 ].
	uniqueAddresses := allAddresses asSet.
	^ uniqueAddresses
]

{ #category : 'printing' }
AddressBookManager >> findFamilyBySurname: aSurname [
	"ВЛАСНИЙ ВАРІАНТ 1: Використання select: для фільтрації
	 Повертає колекцію всіх записів людей із заданим прізвищем (наприклад, усіх Кравчуків)"
	| family |
	family := addressBook select: [ :entry | (entry at: 1) = aSurname ].
	^ family
]

{ #category : 'printing' }
AddressBookManager >> groupPeopleByFirstLetter [
	"ВЛАСНИЙ ВАРІАНТ 4: Використання groupedBy: 
	 Групує всі записи у словник за першою літерою прізвища (зручно для створення алфавітного покажчика)"
	| groupedDict |
	groupedDict := addressBook groupedBy: [ :entry | (entry at: 1) first asUppercase ].
	^ groupedDict
]

{ #category : 'initialization' }
AddressBookManager >> initialize [ 	
	"Ініціалізація впорядкованої колекції за алфавітом прізвищ (перший елемент масиву)"
	addressBook := SortedCollection sortBlock:[:a :b | (a at:1) <= (b at:1)].
]

{ #category : 'initialization' }
AddressBookManager >> printAddressBook [
	 | s |  s := WriteStream on: String new.
    addressBook do:[:x | x do:
        [ :y | s nextPutAll: y; tab; tab.].
        s cr. ].
	 UIManager default edit: s contents label: 'My Address Book'
]

{ #category : 'printing' }
AddressBookManager >> printSameFirstNames [
	"Пошук та друк людей з однаковими іменами (перетворення колекцій Bag, Set)"
	| firstNames duplicates s w |
	
	firstNames := Bag new.        "утворимо торбу імен"
	addressBook do: [ :entry | firstNames add: (entry at: 2) ].
	
	"виберемо ті імена, які зустрічаються більше одного разу"
	duplicates := firstNames select: [ :name | (firstNames occurrencesOf: name) > 1 ].
	
	"і впорядкуємо їх, прибравши дублікати через Set"
	duplicates := duplicates asSet asSortedCollection.
	
	"записуємо результат у потік замість Transcript"
	s := WriteStream on: String new.
	duplicates do: [ :first | 
		s nextPutAll: first; nextPutAll: ' ==>'.
		addressBook do: [ :entry | 
			(entry at: 2) = first ifTrue: [ 
				s space; nextPutAll: (entry at: 1)
			] 
		].
		s cr. 
	].
	
	"відкриваємо фінальний результат у новому текстовому вікні"
	UIManager default edit: s contents label: 'Duplicates'.
]
