package environment;

public class Region {
    int min_x;
    int max_x;
    int min_y;
    int max_y;
    String name;
    int id;

    public Region(int min_x, int max_x, int min_y, int max_y, String name){
        this.min_x = min_x;
        this.max_x = max_x;
        this.min_y = min_y;
        this.max_y = max_y;
        this.name = name;
        this.id = -1;
    }

    public void setId(int id){
        this.id = id;
    }

    public boolean contains(int x, int y){
        return x >= min_x && x <= max_x && y >= min_y && y <= max_y;
    }

    public boolean isEqual(Region region){
        return min_x == region.min_x && max_x == region.max_x && min_y == region.min_y && max_y == region.max_y && name.equals(region.name);
    }

    public String toString(){
        return "Region " + name + "[" + id + "]" + " (" + min_x + ", " + max_x + ", " + min_y + ", " + max_y + ")";
    }

    public boolean isOverlapping(Region region){
        return contains(region.min_x, region.min_y) || contains(region.max_x, region.max_y) || region.contains(min_x, min_y) || region.contains(max_x, max_y);
    }

    public float distance(Region region){
        // if region is contained in this region, return 0
        if ( contains(region.min_x, region.min_y) && contains(region.max_x, region.max_y) ){
            return Float.POSITIVE_INFINITY;
        }
        // if this region is contained in region, return 0
        if ( region.contains(min_x, min_y) && region.contains(max_x, max_y) ){
            return Float.POSITIVE_INFINITY;
        }
        float dx = 0.0f;
        if ( min_x < region.min_x )
            dx = region.min_x - max_x;
        else if (min_x > region.min_x)
            dx = min_x - region.max_x;

        float dy = 0.0f;
        if ( min_y < region.min_y)
            dy = region.min_y - max_y;
        else if (min_y > region.min_y)
            dy = min_y - region.max_y;

        return (float) Math.sqrt( dx*dx + dy*dy );
    }

}