// Room 309
ntpp(region0, room309).
ntpp(region1, room309).
ntpp(region2, room309).
ntpp(region3, room309).
ntpp(region4, room309).

// Room 310
ntpp(region5, room310).
ntpp(region6, room310).
ntpp(region7, room310).
ntpp(region8, room310).
ntpp(region9, room310).

// Room 314
ntpp(region10, room314).
ntpp(region11, room314).
ntpp(region12, room314).
ntpp(region13, room314).
ntpp(region14, room314).

// Regions of room 309
ec(region0, region1).
ec(region1, region0).
ec(region0, region3).
ec(region3, region0).
ec(region1, region2).
ec(region2, region1).
ec(region1, region4).
ec(region4, region1).
ec(region2, region3).
ec(region3, region2).
ec(region3, region4).
ec(region4, region3).

// Regions of room 310
ec(region5, region6).
ec(region6, region5).
ec(region6, region7).
ec(region7, region6).
ec(region7, region8).
ec(region8, region7).
ec(region5, region9).
ec(region9, region5).

// Regions of room 314
ec(region10, region13).
ec(region13, region10).
ec(region10, region14).
ec(region14, region10).
ec(region11, region13).
ec(region13, region11).
ec(region11, region14).
ec(region14, region11).
ec(region12, region13).
ec(region13, region12).
ec(region12, region14).
ec(region14, region12).

// Doors
ntpp(door1, room309).
ntpp(door1, room310).
ntpp(door0, room309).
ntpp(door0, room314).
ec(region0, door1).
ec(door1, region0).
ec(region5, door1).
ec(door1, region5).
ec(door1, room309).
ec(room309, door1).
ec(door1, room310).
ec(room310, door1).

ec(region0, door0).
ec(door0, region0).
ec(door0, region14).
ec(region14, door0).

ec(region0, door0).
ec(door0, region0).
ec(door1, room309).
ec(room309, door1).
ec(door0, room314).
ec(room314, door0).

// Dirt
ntpp(dirt0, region2).
ntpp(dirt1, region8).
ntpp(dirt3, region10).
ntpp(dirt2, region12).