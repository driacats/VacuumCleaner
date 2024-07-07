// Cleaning Robot Agent

clockwise(up, right).
clockwise(right, down).
clockwise(down, left).
clockwise(left, up).

rotation(down).

+!start
    :   true
    <-  .print("Starting robot");
        .my_name(Me);
        .concat(Me, "robot", ArtName);
        makeArtifact(ArtName, "Environment.Robot", [], ArtId);
        focus(ArtId);
        .wait(2000);
        !move;
        .wait(500);
        !stop;
        !rotate(right);
        !move.

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
        -+rotation(Direction);
        .wait(500).

+!clean
    :   true
    <-  .print("Cleaning robot");
        clean.

+warning(Object)
    :   rotation( Direction ) & clockwise( Direction, NewDirection )
    <-  !stop;
        !rotate( NewDirection );
        !move.

+warning(Object)
    :   true
    <-  .print("Warning: ", Object).