# get pdb
fetch 6asi

# technicalities
set dash_gap, 0.2
set dash_length, 0.1
set label_font_id, 7
set label_outline_color, white
set label_color, black
set ray_opaque_background, on
set ray_trace_mode, 0

# clear the field
hide everything
bg_color white

# define selections for ligands, protein and ligand binding pockets
select ATP,     resi 601
select Mg,      resi 602
select Mn,      resi 603
select MetSulf, resi 604
select prot, resi 1-600 & (! element H)
select ligands, ! prot
select article_res, (resi 213+65+209+232) & (! element H)

select pocket_ATP,     (byres all within 3 of ATP) & (! (ligands | solvent)) & (! resi 450-452)
select pocket_MetSulf, (byres all within 2.5 of MetSulf) & (! ligands | solvent | pocket_ATP)
select pocket_Mg,      (byres all within 2 of Mg) & (! ligands | solvent | pocket_ATP | pocket_MetSulf)
select pocket_Mn,      (byres all within 2.5 of Mn) & (! ligands | solvent | pocket_ATP | pocket_MetSulf | pocket_Mg)
select pockets,        pocket_ATP | pocket_MetSulf | pocket_Mg | pocket_Mn

# show protein as cartoon, color everything as "usual"
show cartoon, prot

# show ligands colored
show spheres, Mg | Mn
show sticks,  ATP | MetSulf
show sticks,  pocket_ATP
show sticks,  article_res
show sticks,  pocket_Mn & (! element H) & (! backbone)
# show (coordinated) waters
show spheres, (solvent within 3 of (MetSulf | Mn))

# settings for selections
set sphere_scale, 0.2, (solvent within 5 of (MetSulf | Mn))
set sphere_scale, 0.33, Mg | Mn
set cartoon_transparency, 0.8, prot

# костыль.
hide sticks,  backbone
hide sticks,  resi 288
hide spheres, resi 897 
hide sticks,  resi 252+256+441
hide sticks, MetSulf & element H

# color objects
color gray80,     prot
color deepblue,   ATP
color red,        MetSulf
color gray60,     (pockets | article_res) & sidechain & element C
color red,        (pockets | article_res) & sidechain & element O
color nitrogen,   (pockets | article_res) & sidechain & element N 
color yellow,     MetSulf & element S
color gray60,     MetSulf & element C
color tv_red,     ATP & element O
color lightblue,  ATP & element N

# define important distances 
distance MS_H2O_1,    MetSulf and name O12,   solvent within 2.89 of (MetSulf and name O12)
distance MS_H2O_2,    MetSulf and name OXT,   solvent within 2.89 of (MetSulf and name OXT)
distance Mg_ATP,      (ATP and name O1B+O1G), Mg
distance Mn_H2O,      Mn,                     solvent within 3 of Mn
distance Mn_ATP,      Mn,                     ATP and name O3G
distance R65_MS1,     resi 65 and name NH2,   MetSulf and name OXT
distance R65_MS2,     resi 65 and name NE,    MetSulf and name O11
distance S209_MS,     (resi 209 and name OG), (MetSulf and name O11)
distance K213_Mn,     (resi 213 and name NZ), Mn
distance H232_Mn,     resi 232 and name NE2,  Mn
distance S250_ATP,    resi 250 and name OG,   ATP and name O2G
distance K254_ATP,    ATP and name O2B+O3G,   resi 254 and name NZ
distance T255_Mg,     Mg,                     resi 255 and name OG1
distance D269_Mn,     Mn,                     resi 269 and name OD1
distance E297_Ribose, resi 297 and name OE2,  resi 601 and name O2'
distance R333_ATP1,   resi 333 and name NH1,  ATP and name O1G
distance R333_ATP2,   resi 333 and name NH2,  ATP and name O2G
distance R449_piSt1,  ATP and name N7,        resi 449 and name NE
distance R449_piSt2,  ATP and name N9,        resi 449 and name NH1
distance R449_piSt3,  resi 449 and name NH2,  ATP and name C4
distance T455_ATP,    resi 455 and name OG1,  ATP and name N6

# color distances
color red, Mg_ATP
color 0x4F518C, R449_piSt1
color 0x4F518C, R449_piSt2
color 0x4F518C, R449_piSt3
color gray90, S209_MS
color gray90, R65_MS1
color gray90, R65_MS2
color gray90, MS_H2O_1
color gray90, MS_H2O_2
color gray90, R333_ATP1
color gray90, R333_ATP2
color gray90, K254_ATP
color gray90, E297_Ribose
color gray90, T455_ATP
color gray90, S250_ATP
color manganese, Mn_H2O
color manganese, Mn_ATP
color manganese, K213_Mn
color manganese, H232_Mn
color manganese, D269_Mn

# MetSulf
#orient MetSulf
label name CB and resi 209,        "%s-%s" % (resn, resi)
label name CB and resi 65,         "%s-%s" % (resn, resi)
label MetSulf & name C13,          "MetSulfonate"
label solvent within 2.89 of (MetSulf and name O12+OXT), "H2O"
show sticks, element H and bound_to (resi 209 and name OG | resi 65 and name NE+NH2)
#set_view (\
#     0.970655143,   -0.232519761,    0.061324928,\
#     0.210976079,    0.945814908,    0.246816233,\
#    -0.115388237,   -0.226636991,    0.967119634,\
#     0.000191130,   -0.000062013,  -31.723655701,\
#    18.023424149,    3.938984871,   62.026828766,\
#   -16.598247528,   80.057029724,  -20.000000000 )
#hide sticks,  ATP | pocket_ATP | resi 232 | resi 213 | resi 269
#hide spheres, Mg | Mn
#for d in ["Mg_ATP", "Mn_H2O", "Mn_ATP", "K213_Mn", "H232_Mn", "S250_ATP", "K254_ATP", "T255_Mg", "R333_ATP1", "R333_ATP2", "D269_Mn"]: \
#  cmd.do(f"hide dashes, {d}"), \
#  cmd.do(f"hide labels, {d}")

# ATP Adenosine contacts
#orient resi 601 and name C5
#set fog_start, 0.9
label name CB and resi 297,  "%s-%s" % (resn, resi)
label name CG2 and resi 455, "%s-%s" % (resn, resi)
label name CG and resi 449,  "%s-%s" % (resn, resi)
#hide cartoon, resi 251-261+359-367+380-392+370+430-439+356-368+243-252
#hide spheres, Mg | Mn | solvent
#hide sticks,  MetSulf | (resi 255+333+250+254)
h_add resi 601 and name O2'
#set_view (\
#     0.172505945,    0.852241039,    0.493874907,\
#    -0.316513658,    0.522769630,   -0.791529238,\
#    -0.932757616,   -0.019775622,    0.359929502,\
#     0.000000000,    0.000000000,  -48.679019928,\
#    30.989999771,   16.059999466,   55.669998169,\
#    35.214820862,   62.143218994,  -20.000000000 )

# ATP Phosphate tail contacts
#orient resi 601 and name PB
#set label_position, [-1,1,-1], Mn_ATP
#set stick_transparency, 0.7, ATP and name N1+N3+N6+N7+N9+C2+C4+C5+C6+C8+C1'+C2'+C3'+C4'+O2'+O3'+O4'
#hide sticks,  resi 232+213+65+209+297+449+455+269 | MetSulf
#hide spheres, solvent
#hide cartoon, resi 264-272+279-290+230-236
label name CD and resi 333,   "%s-%s" % (resn, resi)
label name CB and resi 250,   "%s-%s" % (resn, resi)
label name CB and resi 297,   "%s-%s" % (resn, resi)
label name CG and resi 254,   "%s-%s" % (resn, resi)
label name CG2 and resi 255,  "%s-%s" % (resn, resi)
label Mg,                     "Mg"
#label Mn,                     "Mn"
#for d in ["MS_H2O_1", "MS_H2O_2", "Mn_H2O", "R65_MS1", "R65_MS2", "S209_MS", "K213_Mn", "H232_Mn", \
#	   "E297_Ribose", "R449_piSt1", "R449_piSt2", "R449_piSt3", "T455_ATP", "D269_Mn"]: \
#	cmd.do(f"hide dashes, {d}"), \
#	cmd.do(f"hide labels, {d}")
show sticks, element H and (bound_to (resi 333 and name NH1+NH2) | bound_to (resi 254 and name NZ) | bound_to (resi 250 and name OG))
#set_view (\
#    -0.885109365,   -0.405670375,   -0.228061646,\
#     0.132115170,    0.250859827,   -0.958964825,\
#     0.446234554,   -0.878922462,   -0.168443039,\
#    -0.000002347,   -0.000002284,  -42.764472961,\
#    26.088127136,    8.158007622,   57.725589752,\
#    24.216964722,   57.711994171,  -20.000000000 )

# Mn distances
#orient Mn
#hide sticks,  resi 65+209+333+254+250
#hide spheres, Mg
#hide cartoon, resi 504-550+385-391+247-252+399-406
#label Mn,                     "Mn"
#label name CD and resi 213,   "%s-%s" % (resn, resi)
#label name CB and resi 232,   "%s-%s" % (resn, resi)
#label name CB and resi 269,   "%s-%s" % (resn, resi)
#label name PG and ATP,        "Gamma P"
#label solvent within 3 of Mn, "H2O"
#label MetSulf and name S10,   "MetSulfonate"
#for d in ["Mg_ATP", "R65_MS1", "R65_MS2", "S209_MS", "S250_ATP", "K254_ATP", "T255_Mg", \
#	  "E297_Ribose", "R333_ATP1", "R333_ATP2"]: \
#       cmd.do(f"hide dashes, {d}"), \
#       cmd.do(f"hide labels, {d}")
#set_view (\
#     0.761702836,    0.201280937,    0.615866184,\
#    -0.530214131,    0.739947855,    0.413931847,\
#    -0.372395873,   -0.641837358,    0.670346558,\
#     0.000000000,    0.000000000,  -37.177173615,\
#    23.504999161,    2.959000111,   59.506999969,\
#    -7.502606392,   81.856910706,  -20.000000000 )

# Mn angles
#orient Mn
#hide sticks,  resi 65+209+333+254+250
#hide spheres, Mg
#hide cartoon, resi 504-550+385-391+247-252+399-406
label Mn,                     "Mn"
label name CD and resi 213,   "%s-%s" % (resn, resi)
label name CB and resi 232,   "%s-%s" % (resn, resi)
label name CB and resi 269,   "%s-%s" % (resn, resi)
label name PG and ATP,        "Gamma P"
label solvent within 3 of Mn, "H2O"
label MetSulf and name S10,   "MetSulfonate"
angle H2O_Mn_H2O,   resi 728,              Mn, resi 825
angle H2O_Mn_Asp,   resi 728,              Mn, resi 269 and name OD1
angle Asp_Mn_His,   resi 269 and name OD1, Mn, resi 232 and name NE2
angle H2O_Mn_His,   resi 825,              Mn, resi 232 and name NE2
angle H2O_Mn_ATP,   resi 825,              Mn, resi 601 and name O3G
angle H2O_Mn_ATP_1, resi 728,              Mn, resi 601 and name O3G
angle ATP_Mn_Asp,   resi 601 and name O3G, Mn, resi 269 and name OD1
angle ATP_Mn_His,   resi 601 and name O3G, Mn, resi 232 and name NE2
angle H2O_Mn_Lys,   resi 728,              Mn, resi 213 and name NZ
angle H2O_Mn_Lys_1, resi 825,              Mn, resi 213 and name NZ
angle Asp_Mn_Lys,   resi 269 and name OD1, Mn, resi 213 and name NZ
angle His_Mn_Lys,   resi 232 and name NE2, Mn, resi 213 and name NZ
#for d in ["Mg_ATP", "R65_MS1", "R65_MS2", "S209_MS", "S250_ATP", "K254_ATP", "T255_Mg", \
#          "E297_Ribose", "R333_ATP1", "R333_ATP2"]: \
#       cmd.do(f"hide dashes, {d}"), \
#       cmd.do(f"hide labels, {d}")
#set_view (\
#     0.761702836,    0.201280937,    0.615866184,\
#    -0.530214131,    0.739947855,    0.413931847,\
#    -0.372395873,   -0.641837358,    0.670346558,\
#     0.000000000,    0.000000000,  -37.177173615,\
#    23.504999161,    2.959000111,   59.506999969,\
#    -7.502606392,   81.856910706,  -20.000000000 )


