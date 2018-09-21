:- consult(counter).
:- consult(queues).
:- consult(eightPuzzle).
:- (dynamic node/2).

doesntPointToExisting(Node) :-
    \+ node(Node, _),
    \+ node(_, Node).

addNeighboursToQueue([(_, N)], Parent, Queue, NewQueue) :-
    (   doesntPointToExisting(N),
        assert(node(N, Parent)),
        join_queue(N, Queue, NewQueue)
    ;   copy_term(Queue, NewQueue)
    ).

addNeighboursToQueue([(_, N)|T], Parent, Queue, NewQueue) :-
    (   doesntPointToExisting(N),
        assert(node(N, Parent)),
        join_queue(N, Queue, TempNewQueue),
        addNeighboursToQueue(T, Parent, TempNewQueue, NewQueue)
    ;   addNeighboursToQueue(T, Parent, Queue, NewQueue)
    ).

recursiveBuildSolution(Node, PrevPath, Path) :-
    (   node(Node, Parent),
        append(PrevPath, [Parent], NextPath),
        recursiveBuildSolution(Parent, NextPath, Path)
    ;   copy_term(PrevPath, Path)
    ).

buildSolution(Solution, Path) :-
    recursiveBuildSolution(Solution, [[Solution]], PathBuffer),
    reverse(PathBuffer, Path).

recursiveBFS(OpenList, Solution) :-
    serve_queue(OpenList, Expanding, _),
    goal8(Expanding),
    buildSolution(Expanding, Solution).

recursiveBFS(OpenList, Solution) :-
    serve_queue(OpenList, Expanding, NewOpenList),
    succ8(Expanding, Neighbours),
    addNeighboursToQueue(Neighbours, Expanding, NewOpenList, NewOpenList2),
    recursiveBFS(NewOpenList2, Solution).

breadthFirstSearch(InitialState, Solution) :-
    make_queue(OpenList),
    join_queue(InitialState, OpenList, NewOpenList),
    recursiveBFS(NewOpenList, Solution).
