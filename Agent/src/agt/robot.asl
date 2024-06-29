// Cleaning Robot Agent

+!start
    :   true
    <-  .print("Starting robot");
        .my_name(Me);
        .concat(Me, "robot", ArtName);
        makeArtifact(ArtName, "environment.Robot", [], ArtId);
        focus(ArtId);
        .wait(2000);
        !move;
        .wait(500);
        !stop;
        !rotate("right");
        !move;
        .wait(10000);
        !stop.

+!move
    :   true
    <-  .print("Moving robot");
        move.

+!stop
    :  true
    <-  .print("Stopping robot");
        stop.

+!rotate(Direction)
    :   true
    <-  .print("Rotating robot");
        rotate(Direction);
        .wait(500).

+!clean
    :   true
    <-  .print("Cleaning robot");
        clean.