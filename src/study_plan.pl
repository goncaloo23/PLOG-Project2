:-use_module(library(lists)).
:-use_module(library(clpfd)).

get_type(1, 'Individual').
get_type(2, 'Group').

make_tasks([], [], [], []).
make_tasks([[Module, Type]|T], [Start|Starts], [End|Ends], [Task|Tasks]) :-
    study_hours(Module, Type, Time),
    get_type(Type, TypeString),
    Task =.. [task, Start, Time, End, 1, Module-TypeString],
    make_tasks(T, Starts, Ends, Tasks).

all_tasks([], [], [], []).
all_tasks([Student|Students], [Task|Tasks], [Start|Starts], [End|Ends]) :-
    %find all modules where the student is enrolled in
    findall([Module, Type], (enrolled_in(Student, Module), study_hours(Module, Type, _)), Modules),
    length(Modules, Length),

    %create lists for start and end times with as many 
    %elements as modules the student is enrolled in
    length(Start, Length),
    length(End, Length),
    domain(Start, 0, 59),
    domain(End, 1, 60),
    
    %generate list of tasks to use in the cumulative predicate
    make_tasks(Modules, Start, End, Task),
    all_tasks(Students, Tasks, Starts, Ends).

acc_constraints([], [], _).
acc_constraints([StartTimes|StartTimess], [EndTimes|EndTimess], [Task|Tasks]) :-
    maximum(End, EndTimes),
    cumulative(Task),
    labeling([minimize(End)], StartTimes),
    acc_constraints(StartTimess, EndTimess, Tasks).

study(Students) :-
    all_tasks(Students, Tasks, StartTimes, EndTimes),
    write(Tasks),

    acc_constraints(StartTimes, EndTimes, Tasks),
    write(Student), nl,
    write(StartTimes), nl,
    write(EndTimes), nl, nl.

study_time([H|T]):-
    study(H),S
    study_time(T).

study_time([_]).


%enrolled_in(Student, Module).
enrolled_in('Asdrubal', 'ESOF').
enrolled_in('Asdrubal', 'PLOG').
enrolled_in('Asdrubal', 'LTW').
enrolled_in('Asdrubal', 'RCOM').
enrolled_in('Asdrubal', 'LAIG').
enrolled_in('Felismina', 'PLOG').
enrolled_in('Felismina', 'LAIG').
enrolled_in('Bernardete', 'LTW').

%study_hours(Module, Type, Time).
%Type is 1 - individual work, 2 - group work
study_hours('ESOF', 1, 3).
study_hours('ESOF', 2, 8).
study_hours('PLOG', 1, 4).
study_hours('PLOG', 2, 5).
study_hours('LAIG', 1, 1).
study_hours('LAIG', 2, 7).
study_hours('LTW', 1, 3).
study_hours('LTW', 2, 6).
study_hours('RCOM', 1, 3).
study_hours('RCOM', 2, 3).

%group(Module, Students)
group('PLOG', ['Asdrubal', 'Felismina']).


/*  Students is the list of students, then you add a list with their curricular units */
students(Students):-
    curricular_units(Students).

curricular_units([]).
curricular_units([H|T]):-
    write(H), write(' curricular units: '),
    read(CurricularUnits),
    write(CurricularUnits), nl, nl,

    curricular_units(T).
