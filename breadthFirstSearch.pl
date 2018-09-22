:- consult(counter).
:- consult(queues).
:- consult(eightPuzzle).
:- (dynamic node/3).

doesntPointToExisting(Node) :-
    \+ node(Node, _, _),
    \+ node(_, Node, _).

addNeighboursToQueue([(_, N)],  (Parent, GValue), Queue, NewQueue) :-
    (   doesntPointToExisting(N),
        incrementCounter(GValue, expanded),
        assert(node(N, Parent, GValue)),
        join_queue((N, GValue), Queue, NewQueue)
    ;   incrementCounter(GValue, duplicated),
        copy_term(Queue, NewQueue)
    ).

addNeighboursToQueue([(_, N)|T],  (Parent, GValue), Queue, NewQueue) :-
    (   doesntPointToExisting(N),
        incrementCounter(GValue, expanded),
        assert(node(N, Parent, GValue)),
        join_queue((N, GValue), Queue, TempNewQueue),
        addNeighboursToQueue(T,
                             (Parent, GValue),
                             TempNewQueue,
                             NewQueue)
    ;   incrementCounter(GValue, duplicated),
        addNeighboursToQueue(T,
                             (Parent, GValue),
                             Queue,
                             NewQueue)
    ).



recursiveBuildStatistics(GValue, CurrStatistics, Statistics) :-
    (   GValue>=0,
        getValueCounter(GValue, generated, Generated),
        getValueCounter(GValue, expanded, Expanded),
        getValueCounter(GValue, duplicated, Duplicated),
        append(CurrStatistics,
               [stat(GValue, Generated, Duplicated, Expanded)],
               NewStatistics),
        plus(GValue, -1, NextGValue),
        recursiveBuildStatistics(NextGValue, NewStatistics, Statistics)
    ;   copy_term(CurrStatistics, Statistics)
    ).

buildStatistics(Node, Statistics) :-
    node(Node, _, GValue),
    recursiveBuildStatistics(GValue, [], StatisticsBuffer),
    reverse(StatisticsBuffer, Statistics).

recursiveBuildSolution(Node, PrevPath, Path) :-
    (   node(Node, Parent, _),
        append(PrevPath, [Parent], NextPath),
        recursiveBuildSolution(Parent, NextPath, Path)
    ;   copy_term(PrevPath, Path)
    ).

buildSolution(Solution, Path) :-
    recursiveBuildSolution(Solution, [Solution], PathBuffer),
    reverse(PathBuffer, Path).

recursiveBFS(OpenList, Solution, Statistics) :-
    serve_queue(OpenList,  (Expanding, _), _),
    goal8(Expanding),
    buildSolution(Expanding, Solution),
    buildStatistics(Expanding, Statistics).

recursiveBFS(OpenList, Solution, Statistics) :-
    serve_queue(OpenList,  (Expanding, PrevGValue), NewOpenList),
    plus(PrevGValue, 1, GValue),
    succ8(Expanding, Neighbours),
    length(Neighbours, Generated),
    addToCounter(GValue, generated, Generated),
    addNeighboursToQueue(Neighbours,  (Expanding, GValue), NewOpenList, NewOpenList2),
    recursiveBFS(NewOpenList2, Solution, Statistics).

breadthFirstSearch(InitialState, Solution, Statistics) :-
    make_queue(OpenList),
    join_queue((InitialState, 0), OpenList, NewOpenList),
    incrementCounter(0, expanded),
    once(recursiveBFS(NewOpenList, Solution, Statistics)),
    retractall(node(_, _, _)),
    retractall(counter(_, _, _)).
