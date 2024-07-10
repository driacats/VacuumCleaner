// Cleaning Robot Agent

{ include( "map.asl" ) }
// { include( "rcc.asl") }

my_region(region0).
dirt(X) :- X == dirt0 | X == dirt1 | X == dirt2 | X == dirt3.
sameroom(Region1, Region2) :- ntpp(Region1, Room) & ntpp(Region2, Room).

+!start
    :   true
    <-  .print("Starting robot");
        .my_name(Me);
        .concat(Me, "robot", ArtName);
        makeArtifact(ArtName, "Environment.Robot", [], ArtId);
        focus(ArtId);
        .wait(2000);
        .print("Let's start, I'll go to clean every dirt in the lab!");
        !go_to_clean.

+!go_to_clean
    :   ntpp(Dirt, Region) & my_region(Region) & dirt(Dirt)
    <-  .print("I am in the region where I have to clean, go to the dirt!");
        gain(Dirt);
        .wait({+gained});
        .print("Cleaning dirt");
        !clean(Dirt);
        .wait({+cleaned});
        -ntpp(Dirt, Region);
        .print("Let's go to the next dirt");
        !go_to_clean.

+!go_to_clean
    :   ntpp(Dirt, Region) & dirt(Dirt)
    <-  .print("Going to clean");
        !move_to(Region);
        !go_to_clean.

+!go_to_clean
    <-  .print("No dirt to clean").

+!move_to(region)
    :   my_region(CurrentRegion) & not sameroom(CurrentRegion, Region) & ntpp(Region, Room) & ec(Door, Room)
    <-  .print("I am in region ", CurrentRegion, " and I have to go to region ", Region, " in the room ", Room);
        .print("The dirt is in the other room, I should go there passing through ", Door);
        ?find_path(CurrentRegion, Door, Path);
        .reverse(Path, ReversePath);
        !follow_path(ReversePath);
        !move_to(Region).

+!move_to(Region)
    :   my_region(CurrentRegion)
    <-  ?find_path(CurrentRegion, Region, Path);
        .reverse(Path, ReversePath);
        !follow_path(ReversePath).

+!follow_path([]) 
    <- .print("Reached destination").

+!follow_path([Head|Tail]) 
    <-  .print("Moving to ", Head);
        gain(Head);
        .wait({+gained});
        -+my_region(Head);
        !follow_path(Tail).

+gained
    <- .print("Gained region").

+!clean(Dirt)
    :   true
    <-  .print("Cleaning robot");
        clean(Dirt).

find_path(Start, Goal, Path) :-
    find_path_recursive(Start, Goal, [Start], Path).

find_path_recursive(Goal, Goal, Visited, Visited).
find_path_recursive(Current, Goal, Visited, Path) :-
    ec(Current, Next) &
    not .member(Next, Visited) &
    find_path_recursive(Next, Goal, [Next|Visited], Path).