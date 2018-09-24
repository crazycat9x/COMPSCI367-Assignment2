:- (dynamic female/1, male/1, childOf/2).

motherOf(Mom, Child) :-
    female(Mom),
    childOf(Child, Mom).

sisterOf(Sister, Person) :-
    female(Sister),
    childOf(Person, Parent),
    childOf(Sister, Parent).

ancestorOf(Anc, Pre) :-
    (   childOf(Pre, Anc)
    ;   childOf(X, Anc),
        ancestorOf(X, Pre)
    ).

inSameTree(Person1, Person2) :-
    (   Person1==Person2
    ;   ancestorOf(Person2, Person1)
    ;   ancestorOf(Person1, Person2)
    ;   ancestorOf(Anc, Person1),
        ancestorOf(Anc, Person2)
    ).