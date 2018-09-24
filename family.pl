:- (dynamic female/1, male/1, childOf/2).

% Ax,y((Female(x) and ChildOf(y,x)) iff MotherOf(x,y))
motherOf(Mom, Child) :-
    female(Mom),
    childOf(Child, Mom).

% Ax,yEz((x != y and Female(x) and ChildOf(x,z) and ChildOf(y,z)) iff SisterOf(x,y))
sisterOf(Sister, Person) :-
    Sister\==Person,
    female(Sister),
    childOf(Person, Parent),
    childOf(Sister, Parent).

% Ax,y((ChildOf(y,x) or Ez(ChildOf(z,x) and AncestorOf(z,y))) iff AncestorOf(x,y))
ancestorOf(Anc, Pre) :-
    (   childOf(Pre, Anc)
    ;   childOf(X, Anc),
        ancestorOf(X, Pre)
    ), !.

% Ax,y((x = y or AncestorOf(x,y) or AncestorOf(y,x) or Ez(AncestorOf(z,x) and Ancestor(z,y))) iff InSameTree(x,y))
inSameTree(Person1, Person2) :-
    (   Person1==Person2
    ;   ancestorOf(Person2, Person1)
    ;   ancestorOf(Person1, Person2)
    ;   ancestorOf(Anc, Person1),
        ancestorOf(Anc, Person2)
    ), !.