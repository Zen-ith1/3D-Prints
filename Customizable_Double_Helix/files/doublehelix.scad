
// VARIABLES

// Height of the helix
helix_height=150;
// Degrees of rotation
twist_amount=360.0;

/* Arms */
// Distance from center to arms
arm_distance=23;
// Thickness of the arms
arm_thickness=15;
// Width of the arms
arm_width=.35;
// Angle to offset an arm so that they're not straight across.
arm_offset=45;

/* Crossbeams */
// Beam height
beam_height=3;
// Beam width
beam_width=6;
// Beam rounding
beam_roundness=1.5;
// Number of beams
num_beams=10.0;

/* Base */
// Base height
base_height=5;
// Base radius
base_radius=37;
// Ratio of base top radius to bottom
base_taper=.95;


module roundedcube(xx, yy, height, radius) {

difference(){

    cube([xx,yy,height]);

    difference(){
        translate([-.5,-.5,-.2])
        cube([radius+.5,radius+.5,height+.5]);

        translate([radius,radius,height/2])
        cylinder(height,radius,radius,true);
    }
    translate([xx,0,0])
    rotate(90)
    difference(){
        translate([-.5,-.5,-.2])
        cube([radius+.5,radius+.5,height+.5]);

        translate([radius,radius,height/2])
        cylinder(height,radius,radius,true);
    }

    translate([xx,yy,0])
    rotate(180)
    difference(){
        translate([-.5,-.5,-.2])
        cube([radius+.5,radius+.5,height+.5]);

        translate([radius,radius,height/2])
        cylinder(height,radius,radius,true);
    }

    translate([0,yy,0])
    rotate(270)
    difference(){
        translate([-.5,-.5,-.2])
        cube([radius+.5,radius+.5,height+.5]);

        translate([radius,radius,height/2])
        cylinder(height,radius,radius,true);
    }
}
}

// CALCULATIONS
beam_length=arm_distance*2-arm_thickness*.5;
beam_twist=twist_amount/(num_beams+1.0);
beam_delta=helix_height/(num_beams+1.0);
beam_offset=arm_offset*.5;


module arm_footprint(helix_r=50
	,arm_r=10
	) {
  skinny_arm = arm_r * arm_width;
  union() {
    translate([ -helix_r + skinny_arm * .5,0]) 
	  square([skinny_arm,arm_r],center=true);
    rotate([0,0,arm_offset])
      translate([ helix_r - skinny_arm * .5,0]) 
	    square([skinny_arm,arm_r],center=true);
  }
}

module helix_coil(helix_r=100
	, arm_r=10
	, helix_h=100
	) {
  linear_extrude(height=helix_h, convexity=10, twist=-twist_amount, slices=500) 
	arm_footprint(helix_r=helix_r
		,arm_r=arm_r
	);
}

// BASE
linear_extrude(height=base_height, scale=base_taper)    circle(r=base_radius, $fn=400 );

// ARMS
translate([0, 0, base_height])
  helix_coil(helix_h=helix_height
	,arm_r=arm_thickness
	,helix_r=arm_distance
	);

// BEAMS
translate([0, 0, base_height])
 for ( i = [1:1:num_beams]) 
  rotate([0,0,beam_twist*i])
    translate([-.5*beam_length,
            -.5*beam_width,
            .5*beam_height + beam_delta*i])
        rotate([0,90,beam_offset]) //beam
        roundedcube(beam_height,beam_width,beam_length,beam_roundness);

//rotate([0,0,-45])
//translate([100,0,0])
//cube([5,50,5], center=true);
