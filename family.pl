:- dynamic female/1, male/1, childOf/2.

% TEST SET
% male(alex).
% female(sophia).
% childOf(sophia, tom).
% childOf(may,tom).
% childOf(john,alex).
% childOf(john,sophia).

motherOf(Mom, Child) :- female(Mom), childOf(Child, Mom).

sisterOf(Sister, Person) :- female(Sister), childOf(Person,Parent), childOf(Sister, Parent).

ancestorOf(Anc,Pre) :-
  childOf(Pre,Anc);
  childOf(X,Anc), ancestorOf(X,Pre).

inSameTree(Person1, Person2) :-
  Person1 = Person2;
  ancestorOf(Person2, Person1);
  ancestorOf(Person1, Person2);
  ancestorOf(Anc,Person1), ancestorOf(Anc,Person2).