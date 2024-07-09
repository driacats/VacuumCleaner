ntpp(path0, room309).
ntpp(path1, room309).
ntpp(path2, room309).
ntpp(path3, room309).
ntpp(path4, room309).

// Emily Wilkins
ntpp(desk_emily, room309).
po(cabinet_emily, desk_emily).
po(chair_emily, desk_emily).

// Thomas Blackwood
ntpp(desk_thomas, room309).
po(cabinet_thomas, desk_thomas).
po(chair_thomas, desk_thomas).

// Olivia Sinclair
ntpp(desk_olivia, room309).
po(cabinet_olivia, desk_olivia).
po(chair_olivia, desk_olivia).

// Joshua Pemberton
ntpp(desk_joshua, room309).
po(cabinet_joshua, desk_joshua).
po(chair_joshua, desk_joshua).

ec(desk_emily, desk_thomas).
ec(desk_emily, desk_olivia).
ec(desk_olivia, desk_joshua).
ec(desk_joshua, desk_thomas).

// Sophia Fitzgerald
ntpp(desk_sophia, room309).
po(cabinet_sophia, desk_sophia).
po(chair_sophia, desk_sophia).

// Daniel Sutcliffe
ntpp(desk_daniel, room309).
po(cabinet_daniel, desk_daniel).
po(chair_daniel, desk_daniel).

// Isabella Ramsey
ntpp(desk_isabella, room309).
po(cabinet_isabella, desk_isabella).
po(chair_isabella, desk_isabella).

// William Sutton
ntpp(desk_william, room309).
po(cabinet_william, desk_william).
po(chair_william, desk_william).

ec(desk_sophia, desk_william).
ec(desk_sophia, desk_isabella).
ec(desk_isabella, desk_daniel).
ec(desk_daniel, desk_william).

ntpp(locker, room309).

po(door0, room309).
po(door0, room316).

po(door1, room309).
po(door1, room326).

ntpp(table, room326).
po(chair0, table).
po(chair1, table).
po(chair2, table).
po(chair3, table).
po(chair4, table).
po(chair5, table).
po(chair6, table).
po(chair7, table).
po(chair8, table).
po(chair9, table).
po(chair10, table).
po(chair11, table).

ntpp(kitchen, room326).
ntpp(fridge, room326).
ntpp(library, room326).
ntpp(sofa, room326).
ec(kitchen, fridge).
ec(fridge, library).

// Ava Sutherland
ntpp(desk_ava, room326).
po(cabinet_ava, desk_ava).
po(chair_ava, desk_ava).

// Benjamin Thorne
ntpp(desk_benjamin, room326).
po(cabinet_benjamin, desk_benjamin).
po(chair_benjamin, desk_benjamin).

// Lily Mackenzie
ntpp(desk_lily, room326).
po(cabinet_lily, desk_lily).
po(chair_lily, desk_lily).

// Alexander Baxter
ntpp(desk_alexander, room326).
po(cabinet_alexander, desk_alexander).
po(chair_alexander, desk_alexander).

// Isabelle Paterson
ntpp(desk_isabelle, room326).
po(cabinet_isabelle, desk_isabelle).
po(chair_isabelle, desk_isabelle).

// Jacob Stirling
ntpp(desk_jacob, room326).
po(cabinet_jacob, desk_jacob).
po(chair_jacob, desk_jacob).

// Evelyn Sutherland
ntpp(desk_evelyn, room326).
po(cabinet_evelyn, desk_evelyn).
po(chair_evelyn, desk_evelyn).

// Samuel Mackay
ntpp(desk_samuel, room326).
po(cabinet_samuel, desk_samuel).
po(chair_samuel, desk_samuel).