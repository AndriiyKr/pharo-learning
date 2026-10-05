"
process matrix from file
"
Class {
	#name : 'MatrixProcess',
	#superclass : 'Object',
	#category : 'Learning',
	#package : 'Learning'
}

{ #category : 'accessing' }
MatrixProcess >> maxInMatrix [
| flatMatr fStream fName n m mMatr mLines outFile |
(fName:=UIManager default
			chooseFullFileNameMatching: nil 
			label: 'Виберіть файл з числовими даними' ) isNil 
        ifTrue: [ ^'Ви не вибрали файла' ]. 
        fStream := fName asFileReference contents readStream.
fStream skipSeparators. n := Integer readFrom: fStream.
fStream skipSeparators. m := Integer readFrom: fStream.
"cтворюємо звичайний плаский масив розміром n * m"
flatMatr := Array new: (n * m).
1 to: n do: [ :i | 
    fStream nextLine.
    1 to: m do: [ :j | 
        fStream skipSeparators.
        "jбчислюємо лінійний індекс за формулою: (рядок - 1) * кількість_стовпців + стовпець"
        flatMatr at: ((i - 1) * m + j) put: (Integer readFrom: fStream).
    ]
].
fStream close. flatMatr inspect.
"Перебираємо номери рядків (від 1 до n)"
    mLines := (1 to: n) collect: [ :i | 
        "Для кожного рядка перебираємо стовпці (від 2 до m), 
         початковим максимумом беремо перший елемент цього ж рядка"
        (2 to: m) 
            inject: (flatMatr at: ((i - 1) * m + 1)) 
            into: [ :rowMax :j | 
                rowMax max: (flatMatr at: ((i - 1) * m + j)) 
            ]
    ].
    "Глобальний максимум шукаємо вже серед масиву mLines"
    mMatr := mLines at: 1.
    mLines do: [ :x | x > mMatr ifTrue: [ mMatr := x ] ].
        "Побудова імені файла результатів, збереження"
    outFile := fName asFileReference parent / (fName asFileReference basenameWithoutExtension , '_result.txt').
    fStream := outFile writeStream.
    mLines do: [ :x | x printOn: fStream. fStream cr ].
    fStream close.
    ^mMatr.
]

{ #category : 'accessing' }
MatrixProcess >> maxInRowMatrix [
	| matr fStream fName n m mMatr mLines outFile |
        "Вибір файла за допомогою діалогу"
    (fName:=UIManager default
			chooseFullFileNameMatching: nil 
			label: 'Виберіть файл з числовими даними' ) isNil
        ifTrue: [ ^'Ви не вибрали файла' ]. 
        fStream := fName asFileReference contents readStream.
	        "Введення даних"
		 fStream skipSeparators.
 	    n := Integer readFrom: fStream.  
	    matr := Array new: n.
		 fStream skipSeparators.
	    m := Integer readFrom: fStream.
	    matr := matr collect: [ :x | Array new: m ]. 
	    1 to: n do: [ :i |  fStream nextLine.
 		     matr at: i put: (
				 (matr at: i) collect: [ :x |  
						fStream skipSeparators.
						Integer readFrom: fStream. ]
					 )	 ].
    fStream close. matr inspect.
        "Обчислення максимальних елементів"
    mLines:=matr collect: [ :r | r inject: (r at: 1) into: [ :x :y | x max: y] ].
    mMatr:=mLines at: 1.
    mLines do: [ :x | x > mMatr ifTrue: [ mMatr := x ] ].
        "Побудова імені файла результатів, збереження"
    	 outFile := fName asFileReference parent / (fName asFileReference basenameWithoutExtension , '_result.txt').
    fStream := outFile writeStream.
    mLines do: [ :x | x printOn: fStream. fStream cr ].
    fStream close.
    ^mMatr .  
]
