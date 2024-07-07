package Environment;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class Room {
    
    List<Region> regions;
    Map<String, Integer> region_counters;

    public Room(){
        regions = new ArrayList<Region>();
        region_counters = new HashMap<String, Integer>();
    }

    public void addRegion(Region region){
        int id = -1;
        System.out.println(region_counters.toString());
        if ( region_counters.containsKey(region.name) ){
            System.out.println("contains key");
            id = region_counters.get(region.name);
            region_counters.merge(region.name, 1, Integer::sum);
        } else {
            System.out.println("does not contain key");
            region_counters.put(region.name, 1);
            id = 0;
        }
        region.setId(id);
        regions.add(region);
    }

    public void removeRegion(Region region){
        regions.remove(region);
    }

    public boolean contains(int x, int y){
        for(Region region : regions){
            if(region.contains(x, y)){
                return true;
            }
        }
        return false;
    }

    public String getRegionName(int x, int y){
        for(Region region : regions){
            if(region.contains(x, y)){
                return region.name;
            }
        }
        return null;
    }

    public boolean exists(Region region){
        for (Region r : regions){
            if(r.isEqual(region)){
                return true;
            }
        }
        return false;
    }

    public void print(){
        System.out.println(" === Room === ");
        for(Region region : regions){
            System.out.println(region.toString());
        }
    }

}