:- (dynamic female/1, male/1, childOf/2).

% Ax,y((female(x) and childOf(y,x)) iff motherOf(x,y))
motherOf(Mom, Child) :-
    female(Mom),
    childOf(Child, Mom).

% Ax,yEz((x != y and female(x) and childOf(x,z) and childOf(y,z)) iff sisterOf(x,y))
sisterOf(Sister, Person) :-
    Sister\==Person,
    female(Sister),
    childOf(Person, Parent),
    childOf(Sister, Parent).

% Ax,y((childOf(y,x) or Ez(childOf(z,x) and ancestorOf(z,y))) iff ancestorOf(x,y))
ancestorOf(Anc, Pre) :-
    (   childOf(Pre, Anc)
    ;   childOf(X, Anc),
        ancestorOf(X, Pre)
    ).

% Ax,y((x = y or ancestorOf(x,y) or ancestorOf(y,x) or Ez(ancestorOf(z,x) and ancestor(z,y))) iff inSameTree(x,y))
inSameTree(Person1, Person2) :-
    (   Person1==Person2
    ;   ancestorOf(Person2, Person1)
    ;   ancestorOf(Person1, Person2)
    ;   ancestorOf(Anc, Person1),
        ancestorOf(Anc, Person2)
    ).