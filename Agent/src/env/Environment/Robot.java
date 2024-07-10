package Environment;

import org.json.JSONObject;

import cartago.*;
import jason.asSyntax.Literal;

import java.util.List;
import java.util.ArrayList;

import websocket.WsClient;

import java.io.PrintStream;
import java.net.URI;
import java.net.URISyntaxException;

import java.io.OutputStream;

import websocket.WsClientMsgHandler;

// import Environment.Room;
// import Environment.Region;

public class Robot extends Artifact implements WsClientMsgHandler{

    private int port = 9080;
    private String host = "127.0.0.1";
    private WsClient conn;
    // env is a list of rooms. Each room is a list of regions. Each region is a rectangle.
    private List<Room> env = new ArrayList<Room>();
    // actual_room is the index of the room where the robot is.
    private int actual_room = -1;
    
    @OPERATION
    public void init() throws URISyntaxException {

        System.setErr(new PrintStream(new OutputStream() {
                   public void write(int b) {
                       // Non fare nulla
                   }
               }));

        conn = new WsClient( new URI( "ws://" + host + ":" + port ) );
        conn.setMsgHandler(this::handleMsg);
        conn.connect();

        Room room = new Room();
        env.add(room);
        actual_room = 0;
	}


    private void send(JSONObject json){
        conn.send(json.toString());
    }

    @OPERATION
    public void gain(String target) {
        JSONObject json = new JSONObject();
        json.put("type", "gain");
        json.put("target", target);
        send(json);
    }

    @OPERATION
    public void clean(String target) {
        JSONObject json = new JSONObject();
        json.put("type", "clean");
        json.put("target", target);
        send(json);
    }

    void logicalPercept( Region region, int id ){
        String room = "room" + actual_room;
        defineObsProperty( "ntpp", region.name + id, room );
        // TODO: define new room if a door is found
        // if ( region.name.equals("door") ){
        //     defineObsProperty( "", region.name + id, room );
        // }
        for ( Region other_region : env.get( actual_room ).regions ) {
            if ( region.contains( other_region.min_x, other_region.min_y) && region.contains( other_region.max_x, other_region.max_y) ) {
                defineObsProperty( "ntpp", region.name + id, other_region.name + other_region.id );
            }
            else if ( region.distance( other_region) < 1.5 ) {
                defineObsProperty( "ec", region.name + id, other_region.name + other_region.id );
            }
            else if ( region.isOverlapping( other_region) ) {
                defineObsProperty( "po", region.name + id, other_region.name + other_region.id );
            }
        }
    }

    @INTERNAL_OPERATION
    void handleSight(JSONObject data){
        String object = data.getString("object");
        System.out.println("[env] seen " + object);
        float distance = data.getFloat("distance");
        System.out.println("[env] distance " + distance);
        String direction = data.getString("direction");
        // TODO: define warning if distance < 2.0
        // if ( distance < 3.5f){
        //     defineObsProperty("warning", Literal.parseLiteral(object));
        //     System.out.println("[env] warning " + object + " at " + distance + " in " + direction);
        // }
        Region region = new Region(data.getInt("min_x"), data.getInt("max_x"), data.getInt("min_y"), data.getInt("max_y"), object);
        if ( ! env.get( actual_room ).exists( region ) ){
            int id = 0;
            if ( env.get( actual_room ).region_counters.containsKey( object ) )
                id = env.get( actual_room ).region_counters.get( object );
            logicalPercept( region , id );
            env.get( actual_room ).addRegion( region );
        }
        // try{
        //     signal("sight");
        // } catch( Exception e ){
        //     System.out.println("[env] signal");
        // }
    }

    @Override
    public void handleMsg(String msg){
        System.out.println("[env] received " + msg);
        JSONObject json = new JSONObject(msg);
        if (json.getString("type").equals("see")){
            handleSight(json);
        }
        if ( json.getString("type").equals("warning")){
            defineObsProperty("warning", Literal.parseLiteral(json.getString("object")));
            try{
                signal("msg");
            } catch( Exception e ){
                System.out.println("[env] signal");
            }
        }
        if (json.getString("type").equals("inform")) {
            if ( json.getString("code").equals("gained")) {
                signal("gained");
            } else if ( json.getString("code").equals("cleaned")) {
                signal("cleaned");
            }
        }
        else {
            System.out.println("[env] received " + json);
        }
    }
}
