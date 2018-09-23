:- consult(counter).
:- consult(queues).
:- consult(eightPuzzle).
:- (dynamic node/2, parentOf/2).

addNeighboursToQueue([(_, N)], Parent, GValue, Queue, NewQueue) :-
    (   \+ node(N, _),
        assert(node(N, GValue)),
        assert(parentOf(Parent, N)),
        join_queue((N, GValue), Queue, NewQueue)
    ;   incrementCounter(GValue, duplicated),
        copy_term(Queue, NewQueue)
    ).

addNeighboursToQueue([(_, N)|T], Parent, GValue, Queue, NewQueue) :-
    (   \+ node(N, _),
        assert(node(N, GValue)),
        assert(parentOf(Parent, N)),
        join_queue((N, GValue), Queue, TempNewQueue),
        addNeighboursToQueue(T,
                             Parent,
                             GValue,
                             TempNewQueue,
                             NewQueue)
    ;   incrementCounter(GValue, duplicated),
        addNeighboursToQueue(T,
                             Parent,
                             GValue,
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
    (   node(Node, GValue),
        recursiveBuildStatistics(GValue, [], StatisticsBuffer),
        reverse(StatisticsBuffer, Statistics)
    ;   recursiveBuildStatistics(0, [], Statistics)
    ).

recursiveBuildSolution(Node, PrevPath, Path) :-
    (   parentOf(Parent, Node),
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
    incrementCounter(PrevGValue, expanded),
    plus(PrevGValue, 1, GValue),
    succ8(Expanding, Neighbours),
    length(Neighbours, Generated),
    addToCounter(GValue, generated, Generated),
    addNeighboursToQueue(Neighbours, Expanding, GValue, NewOpenList, NewOpenList2),
    recursiveBFS(NewOpenList2, Solution, Statistics).

breadthFirstSearch(InitialState, Solution, Statistics) :-
    assert(node(InitialState, 0)),
    make_queue(OpenList),
    join_queue((InitialState, 0), OpenList, NewOpenList),
    once(recursiveBFS(NewOpenList, Solution, Statistics)),
    retractall(parentOf(_, _)),
    retractall(node(_, _)),
    retractall(counter(_, _, _)).
